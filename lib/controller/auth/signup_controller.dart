import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:car_ticket/domain/repositories/user/firebase_user_repository.dart';
import 'package:car_ticket/domain/usecases/helpers/dialog_helper.dart';
import 'package:car_ticket/presentation/screens/main_screen/navigations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class SignUpController extends GetxController {
  final FirebaseUserRepository _firebaseUserRepository =
      Get.find<FirebaseUserRepository>();
  final TicketAppSharedPreferenceRepository
      _ticketAppSharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  bool isSigningIn = false;

  void signUp({required MyUser myUser, required String password}) async {
    try {
      isSigningIn = true;
      update();

      // Add timestamp and initial booking count to user object
      myUser = myUser.copyWith(
        createdAt: DateTime.now(),
        bookingsCount: 0, // Start with zero bookings
      );

      await _firebaseUserRepository.signUpWithEmailAndPassword(
          myUser, password);

      final response = await _firebaseUserRepository.signInWithEmailAndPassword(
          myUser.email, password);

      // Create complete user object with all required fields
      MyUser user = MyUser(
        id: response.user!.uid,
        email: response.user!.email!,
        name: response.user!.displayName ??
            myUser.name, // Use provided name if displayName is null
        createdAt: DateTime.now(), // Set creation timestamp
        bookingsCount: 0, // Initialize booking count
      );

      await _ticketAppSharedPreferenceRepository.setUser(user);
      await _firebaseUserRepository.setUserData(user: user);
      Get.offAndToNamed(Navigations.routeName);
      isSigningIn = false;
      update();
    } on FirebaseException catch (e) {
      isSigningIn = false;
      DialogBox.show(Get.context!, e.code, e.message!);
      update();
    }
  }
}
