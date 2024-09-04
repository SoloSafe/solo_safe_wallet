import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyGeneration {
  // Generate a mnemonic
  static Future<String> generateMnemonic() async {
    return bip39.generateMnemonic();
  }

  // Generate a private key using the mnemonic
  static Future<String> generatePrivateKey(String mnemonic) async {
    var seed = bip39.mnemonicToSeedHex(mnemonic);
    var privateKey = EthPrivateKey.fromHex(seed);
    return privateKey.privateKeyInt.toRadixString(16);
  }

  // Generate a public key from the private key
  static Future<String> generatePublicKey(String privateKey) async {
    var ethPrivateKey = EthPrivateKey.fromHex(privateKey);
    var publicKey = await ethPrivateKey.extractAddress();
    return publicKey.hex;
  }

  // Save the keys into SharedPreferences
  static Future<void> saveKeys(String privateKey, String publicKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('privateKey', privateKey);
    await prefs.setString('publicKey', publicKey);
  }

  // Retrieve saved keys
  static Future<Map<String, String>> getKeys() async {
    final prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    String? publicKey = prefs.getString('publicKey');
    return {
      'privateKey': privateKey ?? '',
      'publicKey': publicKey ?? '',
    };
  }
}
