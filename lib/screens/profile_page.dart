import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dss/screens/login_screen.dart';
import 'package:smart_dss/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:smart_dss/provider/sign_in_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  String members = ' Loading...';
  String adults = ' Loading...';
  String city = ' Loading...';
  String houseno = ' Loading...';

  Future getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    final DocumentReference d =
        FirebaseFirestore.instance.collection("Residents").doc(email);
    DocumentSnapshot snapshot = await d.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String fetchedMembers = data['members'] ?? 'No members data';
    String fetchedAdults = data['adults'] ?? 'No adults data';
    String fetchedCity = data['city'] ?? 'No house number data';
    String fetchedHouseno = data['houseno'] ?? 'No house number data';
    setState(() {
      members = fetchedMembers;
      adults = fetchedAdults;
      houseno = fetchedHouseno;
      city = fetchedCity;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();
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
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                            size: 40,
                            Icons.arrow_back_rounded,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage("${sp.imageUrl}"),
                      radius: 50,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome ${sp.name}",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "E-mail: ${sp.email}",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Number of Total Members:$members",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Number of Adult Members: $adults ",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "City: $city ",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "House Number: $houseno ",
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Signed in with",
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Text("${sp.provider}".toUpperCase(),
                            style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          sp.userSignOut();
                          nextScreenReplace(context, const LoginScreen());
                        },
                        child: const Text("SIGNOUT",
                            style: TextStyle(
                              color: Colors.red,
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
