import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_safe_wallet/routes/app_routes.dart'; // For app version

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = ""; // Default version

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text("Manage Wallet"),
              leading: Icon(Icons.wallet),
              onTap: () {
                // Handle wallet management
              },
            ),
            Divider(),
            ListTile(
              title: Text("Backup Wallet"),
              leading: Icon(Icons.backup),
              onTap: () {
                // Handle wallet backup
              },
            ),
            Divider(),
            ListTile(
              title: Text("Change PIN"),
              leading: Icon(Icons.lock),
              onTap: () {
                // Handle PIN change
              },
            ),
            Divider(),
            ListTile(
              title: Text("Security Settings"),
              leading: Icon(Icons.security),
              onTap: () {
                // Handle security settings
              },
            ),
            Divider(),
            Spacer(),
            // Log out button
            ListTile(
              title: Text(
                "Log out",
                style: TextStyle(color: Colors.red),
              ),
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              onTap: () {
                _showLogoutConfirmation(context);
              },
            ),
            // Application version display
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  "Version $_appVersion",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Log out"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Clear the private key from SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('private_key');
                prefs.remove('public_key');
                prefs.remove('mnemonic');
                // Navigate to the start auth page remove all history so that the user can't go back
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.startAuth, (route) => false);
              },
              child: Text(
                "Log out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}