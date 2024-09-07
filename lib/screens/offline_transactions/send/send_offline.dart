import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SendOfflinePage extends StatefulWidget {
  @override
  _SendOfflinePageState createState() => _SendOfflinePageState();
}

class _SendOfflinePageState extends State<SendOfflinePage> {
  String? ipAddress;
  int? port;
  bool isConnecting = false;
  bool isConnected = false;
  Socket? socket;

  @override
  void dispose() {
    _disconnectSocket();
    super.dispose();
  }

  Future<void> _connectToServer(String ip, int port) async {
    setState(() {
      isConnecting = true;
    });

    try {
      socket = await Socket.connect(ip, port, timeout: Duration(seconds: 5));
      if (mounted) {
        setState(() {
          isConnected = true;
          isConnecting = false;
        });
      }
    } catch (e) {
      print("Error connecting to server: $e");
      if (mounted) {
        setState(() {
          isConnecting = false;
          isConnected = false;
        });
      }
    }
  }

  Future<void> _disconnectSocket() async {
    await socket?.close();
    if (mounted) {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> _scanQRCode() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR Code scanning feature is coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Send Offline'),
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
                  ElevatedButton(
                    onPressed: _scanQRCode,
                    child: Text('Scan QR Code'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManualInputPage(
                            onSubmit: (ip, port) {
                              ipAddress = ip;
                              this.port = port;
                              _connectToServer(ip, port);
                            },
                          ),
                        ),
                      );
                    },
                    child: Text('Enter IP & Port Manually'),
                  ),
                  SizedBox(height: 20),
                  if (isConnecting)
                    CircularProgressIndicator()
                  else if (isConnected) ...[
                    Icon(Icons.check_circle, color: Colors.green, size: 60),
                    SizedBox(height: 20),
                    Text('Connected to server! Ready to send funds.'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendAmountPage(
                              socket: socket!,
                            ),
                          ),
                        );
                      },
                      child: Text('Send Money'),
                    ),
                  ] else ...[
                    Text('Not connected'),
                  ],
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

// Manual IP and Port Input Page
class ManualInputPage extends StatefulWidget {
  final Function(String ip, int port) onSubmit;

  ManualInputPage({required this.onSubmit});

  @override
  _ManualInputPageState createState() => _ManualInputPageState();
}

class _ManualInputPageState extends State<ManualInputPage> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter IP & Port')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(labelText: 'IP Address'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Port'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final ip = _ipController.text;
                final port = int.tryParse(_portController.text) ?? 0;
                widget.onSubmit(ip, port);
                Navigator.pop(context);
              },
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page for entering the amount to send
class SendAmountPage extends StatefulWidget {
  final Socket socket;

  SendAmountPage({required this.socket});

  @override
  _SendAmountPageState createState() => _SendAmountPageState();
}

class _SendAmountPageState extends State<SendAmountPage> {
  final _amountController = TextEditingController();

  Future<void> _sendAmount() async {
    final amount = _amountController.text;
    final message = "$amount:SEND";
    widget.socket.add(Uint8List.fromList(message.codeUnits));
    print("Amount sent: $amount");

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Transaction Complete"),
        content: Text("Funds sent successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Amount')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter amount to send:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Amount'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendAmount,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}