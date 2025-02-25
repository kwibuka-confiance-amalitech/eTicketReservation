import 'package:car_ticket/domain/repositories/user/firebase_user_repository.dart';
import 'package:car_ticket/domain/repositories/user/user_repository.dart';
import 'package:car_ticket/presentation/screens/auth/auth_screen.dart';
import 'package:car_ticket/presentation/screens/car_all_details/car_available_more_details.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/car/cars.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/dashboard.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/destination/destinations.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/driver/drivers.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/payments.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/report/report_screen.dart';
import 'package:car_ticket/presentation/screens/main_screen/dashboard/users.dart';
import 'package:car_ticket/presentation/screens/main_screen/navigations.dart';
import 'package:car_ticket/presentation/screens/onboarding/onboard_screen.dart';
import 'package:car_ticket/presentation/screens/setting_screens/edit_profile.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_payment.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_tickets.dart';
import 'package:car_ticket/presentation/screens/status_screen/success_payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/route_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = dotenv.env['STRIPE_TEST_PUBLISHABLE_KEY']!;

  runApp(MyApp(
    userRepository: FirebaseUserRepository(firebaseAuth: FirebaseAuth.instance),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp({required this.userRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const AuthScreen(),
              // home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              //   builder: (context, state) {
              //     if (state.status == AuthenticationStatus.authenticated) {
              //       return const Navigations();
              //     } else if (state.status ==
              //         AuthenticationStatus.unauthenticated) {
              //       return const AuthScreen();
              //     }
              //     return const OnboardingScreen();
              //   },
              // ),
              routes: {
                OnboardingScreen.routeName: (context) =>
                    const OnboardingScreen(),
                AuthScreen.routeName: (context) => const AuthScreen(),
                Navigations.routeName: (context) => const Navigations(),
                CarAvailableDetails.routeName: (context) =>
                    const CarAvailableDetails(),
                UserProfileScreen.routeName: (context) =>
                    const UserProfileScreen(),
                CarTicketDashboard.routeName: (context) =>
                    const CarTicketDashboard(),
                // DASHBOARD ROUTES
                CarsScreen.routeName: (context) => const CarsScreen(),
                UsersScreen.routeName: (context) => const UsersScreen(),
                DriversScreen.routeName: (context) => const DriversScreen(),
                DestinationsScreen.routeName: (context) =>
                    const DestinationsScreen(),
                MyPayments.routeName: (context) => const MyPayments(),
                PaymentSuccessScreen.routeName: (context) =>
                    const PaymentSuccessScreen(),
                PaymentsScreen.routeName: (context) => const PaymentsScreen(),
                MyTicketScreen.routeName: (context) => const MyTicketScreen(),
                DashboardReportScreen.routeName: (context) =>
                    const DashboardReportScreen(),
              });
        });
  }
}
