import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_safe_wallet/routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solo_safe_wallet/screens/home_page/widgets/latest_transactions.dart';
import 'package:solo_safe_wallet/screens/home_page/widgets/mainnet_testnet.dart';
import 'package:solo_safe_wallet/screens/home_page/widgets/your_wallet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // To toggle full address display

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SoloSafe Wallet"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network Toggle
            // MainnetTestnet(),
            SizedBox(height: 10),
            YourWallet(),
            SizedBox(height: 30),
            // Tabs for Online and Offline Transactions
            LatestTransactions()
          ],
        ),
      ),
    );
  }
}
