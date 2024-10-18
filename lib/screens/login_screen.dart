// import 'package:smart_dss/profile_setup.dart';
import 'package:smart_dss/provider/internet_provider.dart';
import 'package:smart_dss/provider/sign_in_provider.dart';
import 'package:smart_dss/screens/home_screen.dart';
import 'package:smart_dss/screens/profile_setup.dart';

import 'package:smart_dss/utils/next_screen.dart';
import 'package:smart_dss/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Image(
                        image: AssetImage("assets/images/nirnai.png"),
                        width: 140
                        // fit: BoxFit.cover,
                        ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text("Welcome to NIRNAI",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please Authenticate before you proceed.",
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Custom Elevated Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isLoading ? null : handleGoogleSignIn,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.80, 50),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : Wrap(
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Sign in with Google",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Handling Google Sign-In
  Future<void> handleGoogleSignIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sp = context.read<SignInProvider>();
      final ip = context.read<InternetProvider>();

      await ip.checkInternetConnection();

      if (!ip.hasInternet) {
        openSnackbar(context, "Check your Internet connection", Colors.red);
      } else {
        await sp.signInWithGoogle();

        if (sp.hasError) {
          openSnackbar(context, sp.errorCode.toString(), Colors.red);
        } else {
          bool userExists = await sp.checkUserExists();

          if (userExists) {
            await sp.getUserDataFromFirestore(sp.uid);
            await sp.saveDataToSharedPreferences();
            await sp.setSignIn();
          } else {
            handleFirstSignIn();

            await sp.saveDataToFirestore();
            await sp.saveDataToSharedPreferences();
            await sp.setSignIn();
          }
          handleAfterSignIn();
        }
      }
    } catch (e) {
      // Handle exceptions
      openSnackbar(context, "An error occurred. Please try again.", Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleFirstSignIn() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      nextScreenReplace(context, const ProfileSetup());
    });
  }

  // Handle after sign-in
  void handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      nextScreenReplace(context, const HomeScreen());
    });
  }
}
