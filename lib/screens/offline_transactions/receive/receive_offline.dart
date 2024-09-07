import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:clipboard/clipboard.dart'; // Using clipboard package
import 'package:network_info_plus/network_info_plus.dart'; // For getting WiFi IP address
import 'package:flutter/animation.dart'; // For animation

class ReceiveOfflinePage extends StatefulWidget {
  @override
  _ReceiveCryptoPageState createState() => _ReceiveCryptoPageState();
}

class _ReceiveCryptoPageState extends State<ReceiveOfflinePage>
    with SingleTickerProviderStateMixin {
  String walletAddress = '';
  String wifiIp = '';
  int selectedPort = 0;
  bool isListening = false;
  bool isConnected = false;
  late AnimationController _controller;
  ServerSocket? serverSocket;

  @override
  void initState() {
    super.initState();
    _loadWalletAddress();
    _initializeNetwork();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _loadWalletAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        walletAddress = prefs.getString('public_key') ?? 'No address found';
      });
    }
  }

  Future<void> _initializeNetwork() async {
    final info = NetworkInfo();
    String? ipAddress = await info.getWifiIP();
    if (mounted) {
      setState(() {
        wifiIp = ipAddress ?? 'Unknown IP';
        selectedPort = Random().nextInt(7700) + 32300; // Random port between 32300-40000
      });
    }
  }

  Future<void> _startListening() async {
    try {
      serverSocket = await ServerSocket.bind(wifiIp, selectedPort);
      if (mounted) {
        setState(() {
          isListening = true;
        });
      }
      serverSocket!.listen((Socket client) {
        if (mounted) {
          setState(() {
            isConnected = true;
            isListening = false;
          });
        }
        _controller.stop();
        print('Connection from ${client.remoteAddress}');
        client.listen((data) {
          print('Data received: ${String.fromCharCodes(data)}');
        });
      });
    } catch (e) {
      print("Error starting socket: $e");
    }
  }

  Future<void> _stopListening() async {
    await serverSocket?.close();
    if (mounted) {
      setState(() {
        isListening = false;
        isConnected = false;
        _controller.repeat(reverse: true); // Restart animation
      });
    }
  }

  void _copyAddress() {
    FlutterClipboard.copy(walletAddress).then((value) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address copied to clipboard!')),
        );
      }
    });
  }

  Widget _buildListeningAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildRing(100, 1.0, 1.2, 0.9, 0.0),
        _buildRing(120, 1.0, 1.4, 0.6, 0.2),
        _buildRing(140, 1.0, 1.6, 0.3, 0.4),
      ],
    );
  }

  Widget _buildRing(double size, double beginScale, double endScale,
      double beginOpacity, double delay) {
    return ScaleTransition(
      scale: Tween(begin: beginScale, end: endScale).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: Tween(begin: beginOpacity, end: 0.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(delay, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopListening(); // Ensure that the server socket is properly closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receive Crypto'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'WiFi'),
              Tab(text: 'Bluetooth'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // WiFi Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'WiFi IP: $wifiIp\nPort: $selectedPort',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  if (isListening) ...[
                    _buildListeningAnimation(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _stopListening,
                      child: Text('Stop Listening'),
                    ),
                  ] else if (isConnected) ...[
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    SizedBox(height: 20),
                    Text(
                      'Device Connected. Waiting for transaction...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _startListening,
                      child: Text('Start Listening'),
                    ),
                  ],
                  SizedBox(height: 40),
                  Text(
                    "Scan the QR Code to send crypto",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: "solo://$wifiIp:$selectedPort",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),

            // Bluetooth Tab (Placeholder)
            Center(
              child: Text(
                'Bluetooth feature is under development.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}