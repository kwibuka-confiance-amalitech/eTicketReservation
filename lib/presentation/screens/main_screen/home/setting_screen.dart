import 'package:car_ticket/controller/setting/setting_controller.dart';
import 'package:car_ticket/presentation/screens/setting_screens/edit_profile.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_payment.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_tickets.dart';
import 'package:car_ticket/presentation/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: SettingController(),
          builder: (settingController) {
            if (settingController.isUpdatingUser) {
              return const Center(child: CircularProgressIndicator());
            }
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Container(
                          height: 190,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.9)
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            left: 20,
                            child: UserProfilePicture(
                                imageUrl: settingController.userMe.photoUrl,
                                size: 50)),
                      ],
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(settingController.userMe.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: SettingsItems.settingsItems.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                leading: Icon(
                                    SettingsItems.settingsItems[index].icon),
                                title: Text(
                                    SettingsItems.settingsItems[index].title),
                                onTap: () {
                                  if (SettingsItems
                                          .settingsItems[index].title ==
                                      "Logout") {
                                    settingController.signOut();
                                  }
                                  SettingsItems.settingsItems[index].onTap();
                                });
                          })
                    ],
                  )
                ]))
              ],
            );
          }),
    );
  }
}

class SettingsItems {
  final String title;
  final IconData icon;
  final Function onTap;

  SettingsItems({required this.title, required this.icon, required this.onTap});

  static List<SettingsItems> settingsItems = [
    SettingsItems(
        title: "Edit Profile",
        icon: Icons.person,
        onTap: () {
          Get.toNamed(UserProfileScreen.routeName);
        }),
    SettingsItems(
        title: "Payments",
        icon: Icons.payment,
        onTap: () {
          Get.toNamed(MyPayments.routeName);
        }),
    SettingsItems(
        title: "Tickets",
        icon: Icons.description_outlined,
        onTap: () {
          Get.toNamed(MyTicketScreen.routeName);
        }),
    SettingsItems(title: "Logout", icon: Icons.logout, onTap: () {}),
  ];
}
