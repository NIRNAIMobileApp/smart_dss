import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_dss/api/firebase_api.dart';
import 'package:smart_dss/api/get_server_key.dart';

import 'package:smart_dss/screens/home_screen.dart';
import 'package:smart_dss/utils/next_screen.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final TextEditingController _membersController = TextEditingController();
  final TextEditingController _housenoController = TextEditingController();
  final TextEditingController _adultsController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _membersController.dispose();
    _housenoController.dispose();
    _adultsController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future saveDataToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    String members = _membersController.text;
    String adults = _adultsController.text;
    String houseno = _housenoController.text;
    String city = _cityController.text;

    await FirebaseApi().initNotifications();
    final DocumentReference r =
        FirebaseFirestore.instance.collection("Residents").doc(email);
    await r.update({
      'members': members,
      'adults': adults,
      'city': city,
      'houseno': houseno,
    });

    await GetServerKey().getAccessToken();
  }

  Future<void> saveServerToken(String serverkToken) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    if (email != null) {
      final DocumentReference s =
          FirebaseFirestore.instance.collection("Residents").doc(email);
      await s.update({
        'serverToken': serverkToken,
      });
    }
  }

  void _onSaveAndProceed() {
    // _saveData();

    saveDataToFirestore();
    nextScreen(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/nirnai.png',
                  height: 36,
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Please provide these details to setup your profile.',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 18),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _membersController,
                    decoration: const InputDecoration(
                      labelText: 'Enter member',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _adultsController,
                    decoration: const InputDecoration(
                      labelText: 'Enter adults',
                    ),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Enter City',
                    ),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _housenoController,
                    decoration: const InputDecoration(
                      labelText: 'Enter house no.',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _onSaveAndProceed,
                      child: Text('Submit ',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                          ))),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
