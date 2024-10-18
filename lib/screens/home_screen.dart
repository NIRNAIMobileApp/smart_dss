import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_dss/main.dart';
import 'package:smart_dss/utils/refresh_page.dart';
import 'package:smart_dss/utils/route.dart';
import 'package:smart_dss/provider/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:smart_dss/screens/profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        themeProvider.toggleTheme(); // Toggle the theme mode
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: Icon(
          themeProvider.themeMode == ThemeMode.dark
              ? Icons.sunny
              : Icons.nights_stay,
        ),
      ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getDetails();
    isNotOnAlert;
  }

  String members = ' Loading...';
  String city = ' Loading...';
  String houseno = ' Loading...';
  bool isNotOnAlert = true;

  Future getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;
    final DocumentReference d =
        FirebaseFirestore.instance.collection("Residents").doc(email);
    DocumentSnapshot snapshot = await d.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String fetchedMembers = data['members'] ?? 'No members data';
    String fetchedCity = data['city'] ?? 'No city number data';
    String fetchedHouseno = data['houseno'] ?? 'No house number data';
    bool fetchedAlert = data['isNotOnAlert'] ?? 'No alert data';
    setState(() {
      members = fetchedMembers;
      houseno = fetchedHouseno;
      city = fetchedCity;
      isNotOnAlert = fetchedAlert;
    });
  }

  Future<void> _launchUrl() async {
    final housenoToFind = houseno.toString();
    LatLng startPoint;
    LatLng endPoint;
    if (housenoToFind == "18281") {
      //140
      startPoint = LatLng(11.241325313801942, 75.791850920301854);
      endPoint = LatLng(11.239937072631104, 75.795546131729694);
    } else if (housenoToFind == "14686") {
      //117
      startPoint = LatLng(11.261205132136842, 75.837523788226051);
      endPoint = LatLng(11.259649303383242, 75.830682685580939);
    } else if (housenoToFind == "14070") {
      //119
      startPoint = LatLng(11.26159219879554, 75.801188620616344);
      endPoint = LatLng(11.262011741282116, 75.797789303812834);
    } else if (housenoToFind == "12034") {
      //121
      startPoint = LatLng(11.264589021477109, 75.778997673727346);
      endPoint = LatLng(11.270499653067681, 75.778991166782902);
    } else if (housenoToFind == "12647") {
      //121 //12647
      startPoint = LatLng(11.264589021477109, 75.778997673727346);
      endPoint = LatLng(11.268589255260878, 75.780120700566073);
    } else {
      //122    //13664
      startPoint = LatLng(11.267820402939357, 75.818275964667521);
      endPoint = LatLng(11.263968287780218, 75.814576243543186);
    }

    final String start = '${startPoint.latitude},${startPoint.longitude}';
    final String end = '${endPoint.latitude},${endPoint.longitude}';

    final Uri uri = Uri.https('www.google.com', '/maps/dir/', {
      'api': '1',
      'origin': start,
      'destination': end,
      'travelmode': 'driving',
    });
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    final housenoToFind = houseno.toString();
    final shelterno = findShelterno(housenoToFind);
    // final totalDistance = findDistance(houseno);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      'assets/images/nirnai.png',
                      height: 36,
                    ),
                  ),
                  const Spacer(),
                  const RefreshPage(),
                  const ThemeToggleButton(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                    },
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                            size: 40,
                            Icons.person,
                            color: Theme.of(context).primaryColor)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              isNotOnAlert
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                      child: Center(
                          child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Text(
                                "No Alerts at the moment",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                              ))),
                        ),
                      )),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 4.0,
                                    ),
                                  ),
                                  elevation: 8,
                                  shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'SEVERE FLOOD ALERT!!!',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'URGENT: Severe flooding is expected in your area. Take immediate action to ensure your safety. Evacuate as per advised by the authorities and avoid flood-prone areas.',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .secondaryHeaderColor),
                                          textAlign: TextAlign.justify,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        GestureDetector(
                                          onTap: _launchUrl,
                                          child: Text(
                                            'Tap here to get directions!',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                  elevation: 8,
                                  color: Theme.of(context).cardColor,
                                  shadowColor: const Color.fromRGBO(0, 0, 0, 1),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Evacuation Details',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'House Number:',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              houseno,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Shelter Allotted:',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              shelterno != null
                                                  ? shelterno
                                                  : 'Houseno $housenoToFind not found',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'City:',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              city,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Total Members Alloted',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              members,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
