import 'package:car_ticket/presentation/screens/auth/login_form.dart';
import 'package:car_ticket/presentation/screens/auth/signup_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLogin = true;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    child: const Text('Welcome to Excel Tours',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: isKeyboard ? MediaQuery.of(context).viewInsets.bottom : 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                          _tabController.index == 0 ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                    TabBar(tabs: const [
                      Tab(
                        text: 'Login',
                      ),
                      Tab(
                        text: 'Sign Up',
                      ),
                    ], controller: _tabController),
                    const SizedBox(height: 20),
                    Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            children: const [
                          LoginForm(),
                          SignUpForm(),
                        ]))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
