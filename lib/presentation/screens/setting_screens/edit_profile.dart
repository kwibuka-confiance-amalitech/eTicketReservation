import 'package:car_ticket/controller/setting/edit_profile_controller.dart';
import 'package:car_ticket/controller/setting/setting_controller.dart';
import 'package:car_ticket/presentation/widgets/custom_appbar.dart';
import 'package:car_ticket/presentation/widgets/custom_textfields_decoration.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatelessWidget {
  static const String routeName = '/user-profile';
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingController settingController = Get.put(SettingController());
    return GetBuilder(
        init: EditProfileController(),
        builder: (editProfileController) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: CustomAppBarAndSave(
                title: "Edit Profile",
                isLookingBlue: false,
                showCheckSave: true,
                isLoadingData: editProfileController.isUpdatingUser,
                save: () => editProfileController.updateUserProfile(),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                height: 110,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                top: 2,
                                left: 2,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 215, 215, 215),
                                    border: const Border.fromBorderSide(
                                        BorderSide(
                                            color: Colors.white, width: 2)),
                                    image: editProfileController
                                            .getProfilePicture.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                editProfileController
                                                    .getProfilePicture),
                                            fit: BoxFit.contain)
                                        : null,
                                  ),
                                  child: editProfileController
                                          .isUploadingImageToFirebase
                                      ? Container(
                                          alignment: Alignment.center,
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.grey.withOpacity(0.7),
                                          ))
                                      : editProfileController
                                              .getProfilePicture.isEmpty
                                          ? const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            )
                                          : const SizedBox(),
                                ),
                              ),
                              Positioned(
                                  right: MediaQuery.of(context).size.width / 2 -
                                      80,
                                  bottom: 10,
                                  child: GestureDetector(
                                    onTap: () =>
                                        editProfileController.uploadImage(),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor,
                                          border: const Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.white,
                                                  width: 3)),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          size: 15,
                                          color: Colors.white,
                                        )),
                                  ))
                            ],
                          ),
                        ),
                        const Gap(50),
                        Form(
                            key: editProfileController.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const Gap(5),
                                TextFormField(
                                  controller:
                                      editProfileController.emailController,
                                  // initialValue: user.email,
                                  enabled: false,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      color: Colors.black),
                                  decoration:
                                      customTextFieldDecorationUnLabeled(
                                          labelText: "Email",
                                          hintText: "Enter your email",
                                          context: context),
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    editProfileController.emailController.text =
                                        value;
                                  },
                                ),
                                const Gap(20),
                                Text(
                                  "Full Name",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                                const Gap(5),
                                TextFormField(
                                  controller:
                                      editProfileController.nameController,
                                  // initialValue: user.name,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      color: Colors.black),
                                  decoration:
                                      customTextFieldDecorationUnLabeled(
                                          labelText: "Doe",
                                          hintText: "Enter your first name",
                                          context: context),
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    editProfileController.nameController.text =
                                        value;
                                  },
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ));
        });
  }
}
