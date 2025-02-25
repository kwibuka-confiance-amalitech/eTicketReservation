import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:car_ticket/domain/repositories/user/firebase_user_repository.dart';
import 'package:car_ticket/domain/usecases/helpers/dialog_helper.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/dashboard.dart';
import 'package:car_ticket/presentation/screens/main_screen/navigations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseUserRepository _userRepository =
      Get.put(FirebaseUserRepository(firebaseAuth: FirebaseAuth.instance));
  final TicketAppSharedPreferenceRepository _sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  bool isSigningIn = false;

  login({required String email, required String password}) async {
    try {
      isSigningIn = true;
      update();
      final response =
          await _userRepository.signInWithEmailAndPassword(email, password);
      final MyUser user = MyUser(
        id: response.user!.uid,
        email: response.user!.email!,
        name: response.user!.displayName ?? '',
      );
      await _sharedPreferenceRepository.setUser(user);
      if (response.user!.email!.contains("admin")) {
        Get.offAllNamed(CarTicketDashboard.routeName);
      } else {
        Get.offAllNamed(Navigations.routeName);
      }

      isSigningIn = false;
      update();
    } on FirebaseAuthException catch (e) {
      isSigningIn = false;
      update();
      DialogBox.show(Get.context!, e.code, e.message.toString());
    }
  }
}
