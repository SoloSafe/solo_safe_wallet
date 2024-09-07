import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SendOfflinePage extends StatefulWidget {
  @override
  _SendOfflinePageState createState() => _SendOfflinePageState();
}

class _SendOfflinePageState extends State<SendOfflinePage> {
  bool isBluetoothEnabled = false;
  bool isBluetoothConnected = false;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BluetoothCharacteristic? selectedCharacteristic;
  bool isConnecting = false;

  @override
  void initState() {
    super.initState();
    _checkBluetoothPermissions();
  }

  Future<void> _checkBluetoothPermissions() async {
    // Check and request Bluetooth permissions
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.bluetoothConnect.request().isGranted &&
        await Permission.bluetooth.request().isGranted &&
        await Permission.location.request().isGranted) {
      _startDeviceDiscovery();
    } else {
      print('Bluetooth permissions not granted.');
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();
    }
  }

  Future<void> _startDeviceDiscovery() async {
    setState(() {
      devices.clear();
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        setState(() {
          devices = results.map((result) => result.device).toList();
        });
      }
    }).onDone(() {
      print("Discovery finished");
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
    });

    try {
      await device.connect();

      // Note: You must call discoverServices after every re-connection!
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) {
        // do something with service
        // print services 
        print(service.uuid);
        print(service.characteristics);
      });

      return;

      print('Connected to the device');
      setState(() {
        isBluetoothConnected = true;
        selectedDevice = device;
        isConnecting = false;
      });

      // Navigate to the next page for sending the amount
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SendAmountPage(device: selectedDevice!),
        ),
      );
    } catch (e) {
      print("Error connecting: $e");
      setState(() {
        isConnecting = false;
      });
    }
  }

  @override
  void dispose() {
    if (selectedDevice != null) {
      selectedDevice!.disconnect();
    }
    super.dispose();
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
              Tab(text: 'Bluetooth'),
              Tab(text: 'Hotspot'), // Placeholder for later
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Bluetooth Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startDeviceDiscovery,
                    child: Text('Discover Devices'),
                  ),
                  SizedBox(height: 20),
                  if (devices.isNotEmpty) ...[
                    Expanded(
                      child: ListView.builder(
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          final device = devices[index];
                          return ListTile(
                            title: Text(device.name.isNotEmpty
                                ? device.name
                                : 'Unknown Device'),
                            subtitle: Text(device.id.toString()),
                            trailing: ElevatedButton(
                              onPressed: isConnecting
                                  ? null
                                  : () => _connectToDevice(device),
                              child: Text('Pair'),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else ...[
                    Text('No devices found'),
                  ],
                ],
              ),
            ),
            // Hotspot Tab (Placeholder)
            Center(
              child:
                  Text('Hotspot: Ready to send funds (Implementation pending)'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page for entering the amount to send
class SendAmountPage extends StatefulWidget {
  final BluetoothDevice device;

  SendAmountPage({required this.device});

  @override
  _SendAmountPageState createState() => _SendAmountPageState();
}

class _SendAmountPageState extends State<SendAmountPage> {
  final _amountController = TextEditingController();
  BluetoothCharacteristic? selectedCharacteristic;

  Future<void> _sendAmount() async {
    final amount = _amountController.text;
    if (selectedCharacteristic != null) {
      await selectedCharacteristic!.write(Uint8List.fromList(amount.codeUnits));
      print("Amount sent: $amount");
    }

    await widget.device.disconnect();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _discoverServices();
  }

  Future<void> _discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          setState(() {
            selectedCharacteristic = characteristic;
          });
        }
      }
    }
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
