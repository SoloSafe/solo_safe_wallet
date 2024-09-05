import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_safe_wallet/services/eth_service.dart';
import 'package:web3dart/web3dart.dart';

class YourWallet extends StatefulWidget {
  @override
  _YourWalletState createState() => _YourWalletState();
}

class _YourWalletState extends State<YourWallet> {
  String _address = "";
  bool _showFullAddress = false;

  final ethService = EthService();

  double _onlineBalance = 0; // Replace with actual online balance logic
  double _offlineBalance = 0; // Replace with actual offline balance logic

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String publicKey = prefs.getString("public_key") ?? "";
    print("The public KEY is $publicKey");

    // Ensure the getBalance method is awaited and the result is handled correctly
    final balance = await ethService.getBalance(publicKey);
    print(balance);

    setState(() {
      _address = publicKey;
      _onlineBalance = double.parse(balance
          .getValueInUnit(EtherUnit.ether)
          .toDouble()
          .toStringAsFixed(4));
    });
  }

  String _shortenAddress(String address) {
    if (_showFullAddress) return address;
    return address.isNotEmpty
        ? "${address.substring(0, 3)}...${address.substring(address.length - 4)}"
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Wallet",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 0),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFullAddress = !_showFullAddress;
                  });
                },
                child: Text(
                  "Address: ${_shortenAddress(_address)}",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Text(
                      "Online balance :  ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "$_onlineBalance ETH",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.upload_sharp,
                      color: Colors.yellow,
                    ))
              ]),
              SizedBox(height: 5),
              Divider(color: Colors.white70),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Text(
                      "Offline balance :  ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "$_offlineBalance ETH",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.download_sharp,
                      color: Colors.lightGreenAccent,
                    ))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
