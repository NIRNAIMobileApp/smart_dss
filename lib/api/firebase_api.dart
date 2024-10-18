import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _messaging.requestPermission();

    final String? fCMToken = await _messaging.getToken();

    if (fCMToken != null) {
      await saveToken(fCMToken);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await saveToken(newToken);
    });
  }

  Future<void> saveToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    final DocumentReference r =
        FirebaseFirestore.instance.collection("Residents").doc(email);
    await r.update({
      'FCMToken': token,
    });
  }
}
