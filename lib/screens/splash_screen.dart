import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dss/provider/sign_in_provider.dart';
import 'package:smart_dss/screens/home_screen.dart';
import 'package:smart_dss/screens/login_screen.dart';
import 'package:smart_dss/utils/next_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    final sp = context.read<SignInProvider>();
    Timer(const Duration(seconds: 1), () {
      _controller.reverse().then((value) {
        sp.isSignedIn == false
            ? nextScreen(context, const LoginScreen())
            : nextScreen(context, const HomeScreen());
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              'assets/images/nirnai.png',
              height: 44,
            ),
          ),
        ),
      ),
    );
  }
}
