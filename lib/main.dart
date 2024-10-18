// import 'package:smart_dss/api/firebase_api.dart';
// import 'package:smart_dss/api/firebase_api.dart';
import 'package:smart_dss/provider/internet_provider.dart';
import 'package:smart_dss/provider/sign_in_provider.dart';
import 'package:smart_dss/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:smart_dss/utils/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService.initialize();
  await Firebase.initializeApp();
  // await FirebaseApi().initNotifications();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  final ThemeData lightTheme = ThemeData(
    primaryColor: Color.fromRGBO(67, 85, 223, 1),
    secondaryHeaderColor: Colors.black,
    brightness: Brightness.light,
    cardColor: Color(0xffffffff),
    buttonTheme: ButtonThemeData(
      buttonColor: Color.fromRGBO(67, 85, 223, 1),
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          displayLarge: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
        ),
  );

  final ThemeData darkTheme = ThemeData(
    primaryColor: Color.fromRGBO(67, 85, 223, 1),
    secondaryHeaderColor: Colors.white,
    focusColor: Color.fromRGBO(67, 85, 0, 1),
    brightness: Brightness.dark,
    cardColor: Color.fromARGB(0, 0, 0, 0),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.white,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          displayLarge: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
        ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InternetProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: 'Nirnai',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
