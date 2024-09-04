import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_safe_wallet/routes/app_routes.dart';
import 'package:solo_safe_wallet/screens/auth/create_wallet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _address = "";

  @override
  void initState(){
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _address = prefs.getString("public_key") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SoloSafe"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.pushNamed(context, AppRoutes.settings);
            }),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Welcome to your Home Page!",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Text(
            "Your Address: $_address",
            style: TextStyle(fontSize: 16),
          ),
          
        ],
      ),
    );
  }
}