import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';  // For Clipboard
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart';  // Using clipboard package

class ReceiveCryptoPage extends StatefulWidget {
  @override
  _ReceiveCryptoPageState createState() => _ReceiveCryptoPageState();
}

class _ReceiveCryptoPageState extends State<ReceiveCryptoPage> {
  String walletAddress = '';

  @override
  void initState() {
    super.initState();
    _loadWalletAddress();
  }

  // Fetch the wallet address from SharedPreferences
  Future<void> _loadWalletAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      walletAddress = prefs.getString('public_key') ?? 'No address found';
    });
  }

  // Copy wallet address to clipboard
  void _copyAddress() {
    FlutterClipboard.copy(walletAddress).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Address copied to clipboard!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Crypto'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            // Wallet Address Display
            Text(
              "Your Wallet Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _copyAddress,  // Tap to copy address
              child: Text(
                walletAddress,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(child: Text("copy Address"),
              onPressed: _copyAddress,)
              
            ),
            SizedBox(height: 40),
            // QR Code Display
            Text(
              "Scan the QR Code to send crypto",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Center(
              child: QrImageView(
                data: walletAddress,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}