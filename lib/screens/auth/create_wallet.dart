import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solosafe/screens/home_page/home_page.dart';
import '../../services/key_manager.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({super.key});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  String _mnemonic = '';
  String _privateKey = '';
  String _publicKey = '';
  bool _isMnemonicSaved = false; // Track if the user has saved the mnemonic

  @override
  void initState() {
    super.initState();
    generateKeys();
  }

  Future<void> generateKeys() async {
    // Generate the mnemonic
    final mnemonic = await KeyManager.generateMnemonic();

    // Generate private and public keys
    final privateKey = await KeyManager.generatePrivateKey(mnemonic);
    final publicKey = await KeyManager.generatePublicKey(privateKey);

    // Save the keys into SharedPreferences
    final keyManager = KeyManager();
    await keyManager.saveKeys(privateKey, publicKey);

    setState(() {
      _mnemonic = mnemonic;
      _privateKey = privateKey;
      _publicKey = publicKey;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create your wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Mnemonic Phrase:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _mnemonic,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => _copyToClipboard(_mnemonic),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.copy, size: 16),
                  SizedBox(width: 10),
                  Text('Copy'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Checkbox to confirm the mnemonic is saved
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isMnemonicSaved,
                  onChanged: (bool? value) {
                    setState(() {
                      _isMnemonicSaved = value ?? false;
                    });
                  },
                ),
                Text(
                  'I have saved my mnemonic safely',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 50),

            ElevatedButton(
              onPressed: _isMnemonicSaved
                  ? () async {
                      // Save the private key, public key, and mnemonic to SharedPreferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString('private_key', _privateKey);
                      prefs.setString('public_key', _publicKey);
                      prefs.setString('mnemonic', _mnemonic);

                      // Proceed to the next step (e.g., wallet dashboard)
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    }
                  : () {
                      print('You must save your mnemonic!');
                      // show a dialog
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Warning'),
                              content: Text(
                                'You must save your mnemonic and check I have saved my mnemonic safely.',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          });
                    },
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
