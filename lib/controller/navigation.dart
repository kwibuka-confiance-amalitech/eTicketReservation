import 'package:car_ticket/presentation/screens/main_screen/home/home_screen.dart';
import 'package:car_ticket/presentation/screens/main_screen/home/setting_screen.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  int currentIndex = 0;

  List pages = const [
    HomeScreen(),
    //  ScanQrCodeScreen()
    SettingScreen()
  ];

  void changeIndex(int index) {
    currentIndex = index;
    update();
  }
}
