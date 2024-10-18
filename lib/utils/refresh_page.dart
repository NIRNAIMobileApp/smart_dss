import 'package:flutter/material.dart';
import 'package:smart_dss/screens/home_screen.dart';
// import 'package:smart_dss/utils/notification.dart';

class RefreshPage extends StatefulWidget {
  const RefreshPage({super.key});

  @override
  State<RefreshPage> createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  Future<void> _refreshPage() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: _refreshPage,
    );
  }
}
