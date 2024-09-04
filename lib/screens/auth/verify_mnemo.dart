import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/key_generation.dart';

class VerifyMnemoPage extends StatefulWidget {
  @override
  _VerifyMnemoPageState createState() => _VerifyMnemoPageState();
}

class _VerifyMnemoPageState extends State<VerifyMnemoPage> {
  String _mnemonic = "";
  String _privateKey = "";
  String _publicKey = "";
  Map<int, String> _verificationWords = {};
  List<int> _positionsToVerify = [];
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    generateKeys();
  }

  Future<void> generateKeys() async {
    final mnemonic = await KeyGeneration.generateMnemonic();
    final privateKey = await KeyGeneration.generatePrivateKey(mnemonic);
    final publicKey = await KeyGeneration.generatePublicKey(privateKey);

    await KeyGeneration.saveKeys(privateKey, publicKey);

    setState(() {
      _mnemonic = mnemonic;
      _privateKey = privateKey;
      _publicKey = publicKey;
    });

    generateVerificationWords();
  }

  void generateVerificationWords() {
    // Split the mnemonic into a list of words
    final mnemonicWords = _mnemonic.split(' ');

    // Randomly select four positions for verification
    final random = Random();
    while (_positionsToVerify.length < 4) {
      int position = random.nextInt(mnemonicWords.length);
      if (!_positionsToVerify.contains(position)) {
        _positionsToVerify.add(position);
        _verificationWords[position] = mnemonicWords[position];
        _controllers[position] = TextEditingController();
      }
    }
  }

  void _verifyMnemonic() {
    bool isValid = true;

    for (int position in _positionsToVerify) {
      final enteredWord = _controllers[position]?.text.trim();
      final correctWord = _verificationWords[position];

      if (enteredWord != correctWord) {
        isValid = false;
        break;
      }
    }

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mnemonic verified successfully!')),
      );
      // Proceed to the next step
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect mnemonic words. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crypto Wallet Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Verify Mnemonic Phrase:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: _positionsToVerify.map((position) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _controllers[position],
                    decoration: InputDecoration(
                      labelText: "Enter word #${position + 1}",
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyMnemonic,
              child: Text("Verify Mnemonic"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to the next step
              },
              child: Text("Proceed"),
            ),
            // Show the mnemonic
            
          ],
        ),
      ),
    );
  }
}
