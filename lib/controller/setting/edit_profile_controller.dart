import 'dart:io';

import 'package:car_ticket/controller/setting/setting_controller.dart';
import 'package:car_ticket/domain/models/user/user.dart';
import 'package:car_ticket/domain/repositories/settings/update_user_repository_imp.dart';
import 'package:car_ticket/domain/repositories/user/firebase_user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  UpdateUserRepositoryImplementation updateUserRepository =
      UpdateUserRepositoryImplementation();
  FirebaseUserRepository userRepository =
      Get.put(FirebaseUserRepository(firebaseAuth: FirebaseAuth.instance));
  SettingController settingController = Get.find<SettingController>();

  MyUser userProfile = MyUser.empty;
  bool isUploadingImageToFirebase = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String profilePicture = "";
  bool isUpdatingUser = false;

  @override
  void onInit() {
    getMyProfile();
    nameController.addListener(() {
      userProfile = userProfile.copyWith(name: nameController.text);
    });
    emailController.addListener(() {
      userProfile = userProfile.copyWith(email: emailController.text);
    });
    super.onInit();
  }

  getMyProfile() async {
    try {
      isUploadingImageToFirebase = true;
      update();
      final newUserMe = await userRepository.getUserData();
      userProfile = newUserMe;
      nameController.text = userProfile.name;
      emailController.text = userProfile.email;
      profilePicture = userProfile.photoUrl!;
      isUploadingImageToFirebase = false;

      update();
    } catch (e) {
      rethrow;
    }
  }

  updateUserProfile() async {
    isUpdatingUser = true;
    update();
    try {
      final MyUser userUpdated = MyUser(
        id: userProfile.id,
        name: nameController.text,
        email: emailController.text,
        photoUrl: userProfile.photoUrl,
      );

      if (formKey.currentState!.validate()) {
        await userRepository.updateUserData(
          user: userUpdated,
        );
        await userRepository.getUserData();
        isUpdatingUser = false;
        update();
      }
    } catch (e) {
      isUpdatingUser = false;
      update();
      rethrow;
    }
  }

  uploadImage() async {
    try {
      XFile image = await updateUserRepository.selectImageFromGallery();
      isUploadingImageToFirebase = true;
      update();
      final downloadedUrl =
          await updateUserRepository.uploadImageToFirebase(File(image.path));
      await userRepository.updateProfilePhoto(photoUrl: downloadedUrl);
      userProfile = userProfile.copyWith(photoUrl: downloadedUrl);
      profilePicture = downloadedUrl;
      await settingController.getMyProfile();
      isUploadingImageToFirebase = false;
      update();
    } catch (e) {
      isUploadingImageToFirebase = false;
      update();
      rethrow;
    }
  }

  //  getting data
  String get getProfilePicture {
    if (userProfile.photoUrl!.isEmpty && profilePicture.isEmpty) {
      return "";
    } else if (userProfile.photoUrl!.isNotEmpty && profilePicture.isNotEmpty) {
      return profilePicture;
    } else if (userProfile.photoUrl!.isNotEmpty && profilePicture.isEmpty) {
      return userProfile.photoUrl!;
    } else if (userProfile.photoUrl!.isEmpty && profilePicture.isNotEmpty) {
      return profilePicture;
    }
    return "";
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
