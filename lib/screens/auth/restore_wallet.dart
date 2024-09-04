import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:web3dart/web3dart.dart';
import 'package:hex/hex.dart';

class RestoreWalletPage extends StatefulWidget {
  @override
  _RestoreWalletPageState createState() => _RestoreWalletPageState();
}

class _RestoreWalletPageState extends State<RestoreWalletPage> {
  final _mnemonicController = TextEditingController();
  String? _privateKey;
  String? _publicKey;
  bool _isRestoring = false;

  // Function to restore wallet from mnemonic
  void _restoreWallet() async {
    final mnemonic = _mnemonicController.text.trim();
    
    if (bip39.validateMnemonic(mnemonic)) {
      setState(() {
        _isRestoring = true;
      });

      // Generate seed from mnemonic
      final seed = bip39.mnemonicToSeed(mnemonic);

       // Derive private key from seed using a derivation path
      final root = bip32.BIP32.fromSeed(seed);
      final child = root.derivePath("m/44'/60'/0'/0/0"); // Example derivation path for Ethereum

      var privateKey = HEX.encode(child.privateKey!);

      
      // Derive private key from seed (for simplicity, we'll use the first key)
      // var privateKey = seed.substring(0, 64); // First 32 bytes
      
      // Create credentials to get public key
      final credentials = EthPrivateKey.fromHex(privateKey);
      final publicKey = await credentials.extractAddress();

      setState(() {
        _privateKey = privateKey;
        _publicKey = publicKey.hex;
        _isRestoring = false;
      });
    } else {
      setState(() {
        _privateKey = "Invalid Mnemonic!";
        _isRestoring = false;
      });
    }
  }

  @override
  void dispose() {
    _mnemonicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restore Wallet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Enter your 12/24-word mnemonic:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _mnemonicController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter mnemonic here",
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isRestoring
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _restoreWallet,
                    child: Text("Restore Wallet", style: TextStyle(fontSize: 17),),
                  ),
            SizedBox(height: 20),
            if (_privateKey != null && _publicKey != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Private Key:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SelectableText(
                    _privateKey!,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Public Key:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  SelectableText(
                    _publicKey!,
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey),
                  ),
                ],
              )
            else if (_privateKey == "Invalid Mnemonic!")
              Text(
                "Invalid Mnemonic! Please try again.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: RestoreWalletPage(),
));