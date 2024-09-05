import 'package:flutter/material.dart';
import 'package:solo_safe_wallet/routes/app_routes.dart';
import 'package:solo_safe_wallet/screens/auth/start_auth.dart';
import 'package:solo_safe_wallet/screens/home_page/home_page.dart';
import 'screens/auth/create_wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CheckPrivateKeyExists(),
      routes: AppRoutes.routes
    );
  }
}

class CheckPrivateKeyExists extends StatefulWidget {
  @override
  _CheckPrivateKeyExistsState createState() => _CheckPrivateKeyExistsState();
}

class _CheckPrivateKeyExistsState extends State<CheckPrivateKeyExists> {
  @override
  void initState() {
    super.initState();
    checkForMnemonic();
  }

  Future<void> checkForMnemonic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pr_key = prefs.getString('private_key');

    // Navigate based on the presence of mnemonic
    if (pr_key != null && pr_key.isNotEmpty) {
      // If mnemonic exists, go to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Otherwise, go to AuthPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StartAuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              CircularProgressIndicator()), // Loading indicator while checking
    );
  }
}
