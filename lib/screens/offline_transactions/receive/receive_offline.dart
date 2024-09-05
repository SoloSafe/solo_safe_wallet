import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:hotspot/hotspot.dart'; // Example for hotspot, ensure hotspot package is properly configured

class ReceiveOfflinePage extends StatefulWidget {
  @override
  _ReceiveOfflinePageState createState() => _ReceiveOfflinePageState();
}

class _ReceiveOfflinePageState extends State<ReceiveOfflinePage>
    with SingleTickerProviderStateMixin {
  BluetoothConnection? _bluetoothConnection;
  bool isBluetoothListening = false;
  bool isHotspotListening = false;
  String? bluetoothAddress;

  // Animation controller
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    // _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    // Ensure Bluetooth is enabled
    await FlutterBluetoothSerial.instance.requestEnable();

    // Get Bluetooth address
    bluetoothAddress =
        await FlutterBluetoothSerial.instance.address ?? 'Unknown';
  }

  Future<void> _startBluetoothListening() async {
    setState(() {
      isBluetoothListening = true;
    });

    // Code to start Bluetooth server socket and listen for connections
    try {
      // BluetoothServerSocket serverSocket = await FlutterBluetoothSerial
      //     .instance
      //     .accept(onConnectionComplete: (BluetoothConnection connection) {
      //   setState(() {
      //     _bluetoothConnection = connection;
      //     isBluetoothListening = false;
      //   });
      // });
      // setState(() {
      //     isBluetoothListening = false;
      //   });
    } catch (e) {
      print("Error while listening for Bluetooth: $e");
    }
  }

  Future<void> _startHotspotListening() async {
    setState(() {
      isHotspotListening = true;
    });

    // Example for starting hotspot (make sure you configure a proper package for this)
    // await Hotspot.enableHotspot();
    // Handle logic for listening to incoming connections (hotspot IP or similar)
  }

  @override
  void dispose() {
    _controller.dispose();
    _bluetoothConnection?.dispose();
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
  
  Widget _buildRing(double size, double beginScale, double endScale, double beginOpacity, double delay) {
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
                  if (isBluetoothListening)
                    Column(
                      children: [
                        _buildListeningAnimation(),
                        SizedBox(height: 20),
                        Text('Listening for Bluetooth Connections...'),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: _startBluetoothListening,
                      child: Text('Start Bluetooth Listening'),
                    ),
                ],
              ),
            ),
            // Hotspot Tab
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
                  if (isHotspotListening)
                    Column(
                      children: [
                        _buildListeningAnimation(),
                        SizedBox(height: 20),
                        Text('Listening for Hotspot Connections...'),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: _startHotspotListening,
                      child: Text('Start Hotspot Listening'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}