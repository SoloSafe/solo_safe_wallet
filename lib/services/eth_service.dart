import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart'; // For making HTTP requests
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EthService {
  late Web3Client _client;

  EthService() {
    String rpcUrl = dotenv.env['ETH_RPC_SERVER'] ?? '';
    _client = Web3Client(rpcUrl, Client());    
  }

  // Function to get the balance of an Ethereum address
  Future<EtherAmount> getBalance(String address) async {
    final credentials = EthereumAddress.fromHex(address);
    return await _client.getBalance(credentials);
  }

  // Function to send a transaction
  Future<String> sendTransaction(
      String privateKey, EthereumAddress receiver, EtherAmount amount) async {
    final credentials = EthPrivateKey.fromHex(privateKey);

    final txHash = await _client.sendTransaction(
      credentials,
      Transaction(
        to: receiver,
        value: amount,
      ),
      chainId: null, // Adjust the chain ID if needed (for testnet/mainnet)
    );

    return txHash;
  }

  // Evaluate gas price before sending a transaction
  Future<EtherAmount> estimateGasPrice() async {
    return await _client.getGasPrice();
  }

  // Function to fetch recent block number
  Future<int> getBlockNumber() async {
    return await _client.getBlockNumber();
  }

  // Disconnect the client
  void dispose() {
    _client.dispose();
  }
}