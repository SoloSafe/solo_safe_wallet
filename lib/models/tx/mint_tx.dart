import 'package:secure_enclave/secure_enclave.dart';
import 'package:solosafe/providers/password.dart';

import 'tx.dart';

class MintTx extends Tx {
  final String mintMsg;
  final String devicePubID;
  final String signature;

  MintTx(
      {required super.txId,
      required super.amount,
      required super.to,
      required super.from,
      required super.timestamp,
      required this.mintMsg,
      required this.devicePubID,
      required this.signature});

  factory MintTx.fromJson(Map<String, dynamic> json) {
    return MintTx(
        txId: json['txId'],
        amount: json['amount'],
        to: json['to'],
        from: json['from'],
        timestamp: DateTime.parse(json['timestamp']),
        mintMsg: json['mintMsg'],
        devicePubID: json['devicePubID'],
        signature: json['verificationHash']);
  }

  Map<String, dynamic> toJson() {
    return {
      'txId': txId,
      'amount': amount,
      'to': to,
      'from': from,
      'timestamp': timestamp.toIso8601String(),
      'mintMsg': mintMsg,
      'devicePubID': devicePubID,
      'verificationHash': signature
    };
  }

  @override
  String toString() {
    return 'MintTx{txId: $txId, amount: $amount, to: $to, from: $from, timestamp: $timestamp, mintMsg: $mintMsg, devicePubID: $devicePubID, signature: $signature}';
  }

  Future<bool> verify() async {
    // check the signature of the mint message using secure enclave device_id
    final secureEnclave = SecureEnclave();
    final verif = await secureEnclave.verify(
        plainText: mintMsg,
        signature: signature,
        password: getSecureEnclavePassword(),
        tag: getSecureEnclaveDeviceIdTag()
    );

    return verif.value!;
  }

  Future<void> mint() async {
    // Mint the asset using the mint message
    if (await verify()) {
      // mint the asset
      // TODO after #11
    } else {
      throw Exception('MintTx verification failed');
    }
  }
}
