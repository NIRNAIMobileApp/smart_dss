import 'package:google_sign_in/google_sign_in.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetServerKey {
  Future<String> getAccessToken() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/firebase.messaging',
      ],
    );

    final GoogleSignInAccount? account = await _googleSignIn.signIn();

    if (account == null) {
      throw Exception('User sign-in failed');
    }

    final GoogleSignInAuthentication authentication =
        await account.authentication;

    final String? accessToken = authentication.accessToken;

    if (accessToken == null) {
      throw Exception('Failed to obtain access token');
    }

    await saveServerToken(accessToken);
    return accessToken;
  }

  // Future<String> getServerKeyToken() async {
  //   final scopes = [
  //     'https://www.googleapis.com/auth/userinfo.email',
  //     'https://www.googleapis.com/auth/firebase.database',
  //     'https://www.googleapis.com/auth/firebase.messaging',
  //   ];

  //   final serviceAccountCredentials = ServiceAccountCredentials.fromJson({
  //     "type": "service_account",
  //     "project_id": "focus-flight-430011-b2",
  //     "private_key_id": "1fdb9a14152929f9e2ed09543ef19d10cc9dd1f7",
  //     "private_key":
  //         "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDAO1gni3SL+fhL\nu5wm4fDUFJLNldLGYG99OlBQCj/wpiR2iYszxrZpHbemsaL6VCoJTiDfkQMwRyMw\nISk5WTRLXXWRrUjc9g60ctCphgbI886vWJ8ji1rpoGEjJODM1X4KcThhSpJnlqce\nq8yCfdrO7sO6Ob2CukYS8/L30cUhal+8nDQp0pwyO3Ge8zd2zDgblXG+RtgLvFUt\nRhImZTf9CvUX8Y3WNj2dziT0bir5DNdnNkCwCSiBE0uFa8BUENVOSl/E85z1r56m\nz3SVwNsAJz8XB/ECZXn6H+es65EIKWvpQilAeZdgttT+cN8TQgVVisYTT977b9lJ\nV1I3cJwrAgMBAAECggEAA3BMUxDEj0hzxO8LNmAuTaznNLRBu/i3pdbS3vZVTyRk\nXJZ4nf7SU9kLPaPJ1Y6HM06+zyD/R0V5KgA924puoWEqRuaBpNTl+HEMAyxO7MNS\nZtfqqNkc/Dbj5fFf8BTAQhw6X6B/iUjW886A7wikpF+oXVQbwWiRnlSCJnq4ewYt\nxnvm/wUzwxfwhIUHGI0Mm+ubQaepRyKOPbsu9Y6airy6ROcqJHN7kzI6tO/PUFT3\nuewVXN6yBqLtkHocyYkmvJEa8eRpk2OZNO2i0dgCdrsxYUoUXr0Qtw6yyEhCuihR\nYi6wLaTb3JiaumILjS5LQndHAM10caNEocswqhUAuQKBgQD7d/doAhkPXeBc0BQ0\nSDPaomWjo4MPWHLIw+aZh16LBNtam86Qn+oWnCjnP8Zeu6zm/pULdbnL6TbC5LXi\n2D8n3BiBZqblRvUrVd3kWHVdGIKHVw5cIuyAqViSLLcvBQrEGl/D8utpYEr2qQ2n\nnxcEOfmHTKSCdeJaMfgd3cyVLQKBgQDDsh3QZNMS6mc/zJGAw0WkOzIrJR5r3Z0/\nMTuCEVP0z5VcjJCsNW7d/v64ZGbQpiFBOph71/V9WUXQ5FRXs3GJQjA6coelvzak\n/TKL6bJ+izQEACXEJyXSffab9w9nYUyc7ROFxGmHbuL0LE+mjcAy8rAmqlO992Kj\nLmmDaad9twKBgQDXSv1xeaJU6q2FKMyzekGS5MiaEgrKH5KeWkJanXAPG4hlidGP\nNqom02mdmpdOUeWVGs8mMZNxhehRcZhbb4KasK/2UZl/4IFUqb5Amo9YtfxCvQDZ\nVzkeal4fP9NRmUJ/ZIkq7RYpcLydc1zybp05DB2bfb22yBCT4gYoI9XcvQKBgEmH\nMwyJ1YTV7dVa15C5zgDW/RKY78U3j02fAezs9c6V8FjFt9X8fZuLo8lEcB0VTolj\nqsddbS+by0+hes847P/VjqlnPvBX2ABF4igPtrE1PGYEaCw7SUq9aVtQiMkfFdog\neaVZFw177Gox+/toZz69UNI2TSCjQrxtQ9fMatIhAoGASTvSt8d/FT/DNg+L/jtC\nmWX5LwebCll5ACM9EXXfpJc8iifHSYR1L3HCNCUiuphN9PZlRlySc/gHf6uvMNzL\nfia9F+hIeB8hHwAtdkYej8DSygur3uA8ehsJW7fRgx4qeOmhd6Mx9PlVikNDthzn\nQtwi611Ts4yGf2EPvk73Uow=\n-----END PRIVATE KEY-----\n",
  //     "client_email":
  //         "firebase-adminsdk-m5gr9@focus-flight-430011-b2.iam.gserviceaccount.com",
  //     "client_id": "101006844314278789173",
  //     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  //     "token_uri": "https://oauth2.googleapis.com/token",
  //     "auth_provider_x509_cert_url":
  //         "https://www.googleapis.com/oauth2/v1/certs",
  //     "client_x509_cert_url":
  //         "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-m5gr9%40focus-flight-430011-b2.iam.gserviceaccount.com",
  //     "universe_domain": "googleapis.com"
  //   });

  //   final client = await clientViaServiceAccount(
  //     serviceAccountCredentials,
  //     scopes,
  //   );

  //   final serverToken = client.credentials.accessToken.data;

  //   print("server token bhai: $serverToken");

  //   await saveServerToken(serverToken);

  //   return serverToken;
  // }

  Future<void> saveServerToken(String serverkToken) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    if (email != null) {
      final DocumentReference s =
          FirebaseFirestore.instance.collection("Residents").doc(email);
      await s.update({
        'accessToken': serverkToken,
      });
    }
  }
}
