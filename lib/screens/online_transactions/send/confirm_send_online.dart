import 'package:flutter/material.dart';

class ConfirmSendOnlinePage extends StatelessWidget {
  final String asset;
  final double amount;
  final String recipient;
  final double networkFee;
  final double totalAmount;

  ConfirmSendOnlinePage({
    required this.asset,
    required this.amount,
    required this.recipient,
    required this.networkFee,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '- $amount $asset',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                '≈ \$${(amount * 0.99).toStringAsFixed(2)}', // Assuming 0.99 as example conversion
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset
                  Row(
                    children: [
                      Icon(
                        Icons.currency_exchange, // Placeholder for asset icon
                        color: Colors.green,
                        size: 14,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '$asset - Starknet',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Wallet Address (Main Wallet)
                  Text(
                    'Wallet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Main Wallet (0x8D714...7C0bA49)', // Example truncated wallet address
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Recipient Address
                  Text(
                    'To',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    recipient,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Network Fee Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Network fee',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$networkFee MATIC ≈ \$${(networkFee * 0.99).toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Max Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '\$$totalAmount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Confirm transaction logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Transaction confirmed!')),
                  );
                  Navigator.pop(context); // Return after confirmation
                },
                child: Text('Confirm'),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}