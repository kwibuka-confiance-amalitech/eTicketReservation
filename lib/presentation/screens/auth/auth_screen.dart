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
  var index = 0;
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    // Add listener to handle tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          index = _tabController.index;
          isLogin = index == 0;
        });
      }
    });
  }

  // Don't forget to dispose the controller
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                      child: Text(index == 0 ? 'Login' : 'Sign Up',
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
