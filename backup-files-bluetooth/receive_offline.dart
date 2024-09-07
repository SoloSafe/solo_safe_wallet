import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ReceiveOfflinePage extends StatefulWidget {
  @override
  _ReceiveOfflinePageState createState() => _ReceiveOfflinePageState();
}

class _ReceiveOfflinePageState extends State<ReceiveOfflinePage>
    with SingleTickerProviderStateMixin {
  bool isBluetoothListening = false;
  String? bluetoothAddress;
  String receivedAmount = '';
  BluetoothCharacteristic? selectedCharacteristic;
  BluetoothDevice? selectedDevice;
  List<BluetoothDevice> devices = [];
  bool isConnecting = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      await FlutterBluePlus.turnOn();
    }
    bluetoothAddress = await FlutterBluePlus.adapterName ?? 'Unknown';
    _startDeviceDiscovery();
  }

  Future<void> _startDeviceDiscovery() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results.map((result) => result.device).toList();
      });
    }).onDone(() {
      print("Device Discovery completed");
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      isConnecting = true;
    });

    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.properties.read) {
            setState(() {
              selectedCharacteristic = characteristic;
            });
          }
        }
      }
      setState(() {
        selectedDevice = device;
        isBluetoothListening = true;
        isConnecting = false;
      });
    } catch (e) {
      print("Error while connecting to the device: $e");
      setState(() {
        isConnecting = false;
      });
    }
  }

  Future<void> _startListeningForMessages() async {
    if (selectedCharacteristic != null && selectedDevice != null) {
      List<int> value = await selectedCharacteristic!.read();
      setState(() {
        receivedAmount = String.fromCharCodes(value);
      });
    }
  }

  @override
  void dispose() {
    if (selectedDevice != null) {
      selectedDevice!.disconnect();
    }
    _controller.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Receive Offline'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Bluetooth'),
              Tab(text: 'Hotspot'),
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
                  Text(
                    'Bluetooth Address: $bluetoothAddress',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (!isBluetoothListening) ...[
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
                    _buildListeningAnimation(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startListeningForMessages,
                      child: Text('Receive Funds'),
                    ),
                    if (receivedAmount.isNotEmpty)
                      Text(
                        'Received Amount: $receivedAmount',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ],
                ],
              ),
            ),
            // Hotspot Tab (Placeholder)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hotspot: Ready to receive funds',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}