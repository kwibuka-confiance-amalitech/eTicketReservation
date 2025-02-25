import 'dart:convert';

import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/domain/models/seat.dart';
import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/repositories/car_repository/car_repository_imp.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:car_ticket/presentation/screens/status_screen/success_payment_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PaymentRepositoryImpl extends PaymentRepository {
  Map<String, dynamic>? paymentIntent;
  final _paymentCollection = FirebaseFirestore.instance.collection('payments');
  final _ticketsCollection = FirebaseFirestore.instance.collection('tickets');
  TicketAppSharedPreferenceRepository sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  CarRepositoryImp carRepository = CarRepositoryImp();

  @override
  String calculateAmount(String price) {
    final calculatedAmount = (int.parse(price)) * 100;
    return calculatedAmount.toString();
  }

  @override
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ${dotenv.env['STRIPE_TEST_SECRET_KEY']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('Error occured while creating payment intent: $err');
      Fluttertoast.showToast(
          msg: 'Error occured while creating payment intent');
    }
  }

  @override
  Future<void> displayPaymentSheet(
      String carId,
      List<Seat> carSeats,
      String clientSecret,
      String destinationId,
      String carDestinationFromTime,
      String carDestinationToTime) async {
    try {
      final user = await sharedPreferenceRepository.getUser();
      Uuid uuid = const Uuid();

      await Stripe.instance.presentPaymentSheet();
      final result = await Stripe.instance.retrievePaymentIntent(clientSecret);

      UserPayment userPayment = UserPayment(
        id: uuid.v4(),
        userId: user.id,
        paymentIntentId: result.id,
        paymentDescription: 'Payment for car ticket',
        paymentAmount: result.amount.toString(),
        paymentCurrency: result.currency,
        destinationId: destinationId,
        paymentStatus: convertPaymentIntentsStatusIntoString(result.status),
        paymentDate: DateTime.now().toString(),
        paymentTime: DateTime.now().toString(),
        carId: carId,
        seats: carSeats,
      );
      await saveCustomerPaymentsInDb(userPayment);
      await carRepository.updateCarSeatsBooked(carId, carSeats);
      await createTicket(
          carId: carId,
          carSeats: carSeats,
          destinationId: destinationId,
          carDestinationFromTime: carDestinationFromTime,
          carDestinationToTime: carDestinationToTime,
          ticketAmount: result.amount.toString());
      Get.offNamed(PaymentSuccessScreen.routeName);
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(msg: 'Error from Stripe: ${e.error}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: $e');
      }
    }
  }

  @override
  Future<void> stripeMakePayment(
      String amount,
      String currency,
      String carId,
      List<Seat> carSeats,
      String destinationId,
      String carDestinationFromTime,
      String carDestinationToTime) async {
    try {
      final user = await sharedPreferenceRepository.getUser();
      paymentIntent = await createPaymentIntent(amount, currency);

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            billingDetails: BillingDetails(
                email: user.email, name: user.name, address: null),
            style: ThemeMode.light,
            merchantDisplayName: 'Car Ticket',
            allowsDelayedPaymentMethods: true,
          ))
          .then((value) {});

      displayPaymentSheet(carId, carSeats, paymentIntent!['client_secret'],
          destinationId, carDestinationFromTime, carDestinationToTime);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Future<void> saveCustomerPaymentsInDb(UserPayment userPayment) async {
    try {
      await _paymentCollection
          .doc(userPayment.id)
          .set(userPayment.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserPayment>> getCustomerPayments(String userId) async {
    try {
      final response =
          await _paymentCollection.where('userId', isEqualTo: userId).get();
      return response.docs
          .map((e) => UserPayment.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserPayment>> getAllPayments() async {
    try {
      final response = await _paymentCollection.get();
      return response.docs
          .map((e) => UserPayment.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> createTicket(
      {required String carId,
      required List<Seat> carSeats,
      required String destinationId,
      required String carDestinationFromTime,
      required String ticketAmount,
      required String carDestinationToTime}) async {
    try {
      final user = await sharedPreferenceRepository.getUser();
      Uuid uuid = const Uuid();
      final ticket = ExcelTicket(
        id: uuid.v4(),
        carId: carId,
        destinationId: destinationId,
        userId: user.id,
        seatNumbers: carSeats.map((seat) => seat.seatNumber).join(','),
        seats: carSeats,
        isExpired: false,
        isUsed: false,
        carDestinationFromTime: carDestinationFromTime,
        carDestinationToTime: carDestinationToTime,
        createdAt: DateTime.now(),
        price: ticketAmount,
      );

      await _ticketsCollection.doc(ticket.id).set(ticket.toDocument());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExcelTicket>> getTickets() async {
    try {
      final user = await sharedPreferenceRepository.getUser();
      final response =
          await _ticketsCollection.where('userId', isEqualTo: user.id).get();
      return response.docs
          .map((e) => ExcelTicket.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ExcelTicket>> getMyTickets({required String userId}) async {
    try {
      final response =
          await _ticketsCollection.where('userId', isEqualTo: userId).get();
      return response.docs
          .map((e) => ExcelTicket.fromDocument(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTicket(ExcelTicket ticket) {
    try {
      return _ticketsCollection.doc(ticket.id).update(ticket.toDocument());
    } catch (e) {
      rethrow;
    }
  }
}

String convertPaymentIntentsStatusIntoString(PaymentIntentsStatus status) {
  switch (status) {
    case PaymentIntentsStatus.Canceled:
      return 'requires_action';
    case PaymentIntentsStatus.Processing:
      return 'requires_payment_method';
    case PaymentIntentsStatus.Succeeded:
      return 'succeeded';
    default:
      return 'unknown';
  }
}
