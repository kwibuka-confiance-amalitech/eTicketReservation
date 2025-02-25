import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/user/firebase_user_repository.dart';
import 'package:car_ticket/presentation/screens/auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final FirebaseUserRepository _firebaseUserRepository =
      Get.put(FirebaseUserRepository(firebaseAuth: FirebaseAuth.instance));
  MyUser userMe = MyUser.empty;
  bool isUpdatingUser = false;
  bool isSigningOut = false;

  @override
  void onInit() {
    getMyProfile();
    super.onInit();
  }

  getMyProfile() async {
    try {
      isUpdatingUser = true;
      update();
      final newUserMe = await _firebaseUserRepository.getUserData();
      userMe = newUserMe;
      isUpdatingUser = false;
      update();
    } catch (e) {
      isUpdatingUser = false;
      update();
      rethrow;
    }
  }

  void signOut() async {
    try {
      isSigningOut = true;
      update();
      await _firebaseUserRepository.signOut();
      Get.offAllNamed(AuthScreen.routeName);
      isSigningOut = false;
      update();
    } catch (e) {
      isSigningOut = false;
      update();
      rethrow;
    }
  }
}
