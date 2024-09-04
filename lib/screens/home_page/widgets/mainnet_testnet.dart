import 'package:flutter/material.dart';

class MainnetTestnet extends StatefulWidget {
  @override 
  _MainnetTestnetState createState() => _MainnetTestnetState();
}

class _MainnetTestnetState extends State<MainnetTestnet>{
  bool _isTestnet = true; // To toggle between testnet and mainnet

  _toggleNetwork(bool isTestnet) {
    setState(() {
      _isTestnet = isTestnet;
    });
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Testnet"),
                Switch(
                  value: !_isTestnet,
                  onChanged: (value) {
                    _toggleNetwork(!value);
                  },
                ),
                Text("Mainnet"),
              ],
            ),
    );
  }
}