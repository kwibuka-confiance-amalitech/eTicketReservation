import 'package:car_ticket/controller/home/destinations.dart';
import 'package:car_ticket/domain/models/carSeats.dart';
import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository_imp.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:get/get.dart';

class SelectedDestinationController extends GetxController {
  CarSeats carSeats = CarSeats.empty;
  bool isGettingCarSeats = false;
  bool showPaymentSheet = false;
  final selectedDestination =
      Get.find<HomeJourneyDestinationController>().selectedDestination.obs;
  final CarRepositoryImp carRepository = Get.put(CarRepositoryImp());
  final PaymentRepositoryImpl paymentRepository =
      Get.put(PaymentRepositoryImpl());
  List<Seat> selectedSeats = [];
  String? selectedDestinationOption;
  String? selectedPickupLocation;

  @override
  void onInit() {
    getCarSeats(selectedDestination.value.carId);
    super.onInit();
  }

  getCarSeats(String id) async {
    try {
      isGettingCarSeats = true;
      update();
      final carSeatsUpdated = await carRepository.getCarSeats(id);
      carSeats = carSeatsUpdated;
      isGettingCarSeats = false;
      update();
    } catch (e) {
      isGettingCarSeats = false;
      update();
      rethrow;
    }
  }

  toogleCarSeatAndChangeIsReserved(Seat selecteSeat) {
    if (selecteSeat.isBooked) {
      return;
    }
    List<Seat> seatsList = carSeats.seatsList.map((seat) {
      if (seat.id == selecteSeat.id && !seat.isReserved) {
        seat.isReserved = true;
        selectedSeats.add(seat.copyWith(isBooked: true));
      } else if (seat.id == selecteSeat.id && seat.isReserved) {
        seat.isReserved = false;
        selectedSeats.removeWhere((element) => element.id == seat.id);
      }
      return seat;
    }).toList();
    carSeats = carSeats.copyWith(seatsList: seatsList);
    update();
  }

  Future<void> payPriceHandler({
    required String carId,
    required List<Seat> seats,
    required String pickupLocation,
  }) async {
    try {
      showPaymentSheet = true;
      update();

      final amount = double.parse(selectedDestination.value.price).toInt() *
          selectedSeatsCount;
      const currency = 'rwf';

      await paymentRepository.stripeMakePayment(
        amount.toString(),
        currency,
        carId,
        seats,
        selectedDestination.value.id,
        selectedDestination.value.from,
        selectedDestination.value.to,
        pickupLocation,
      );

      showPaymentSheet = false;
      update();
      Get.back();
    } catch (e) {
      showPaymentSheet = false;
      update();
      rethrow;
    }
  }

  saveCustomerPaymentsInDb(UserPayment userPayment) async {
    try {
      await paymentRepository.saveCustomerPaymentsInDb(userPayment);
      Get.back();
    } catch (e) {
      rethrow;
    }
  }

  void selectedPickupLocationHandler(String? value) {
    if (value != null && value.isNotEmpty) {
      selectedPickupLocation = value;
      print('Selected pickup location: $value'); // Debug print
      update();
    }
  }

  get selectedSeatsCount => selectedSeats.length;
}
