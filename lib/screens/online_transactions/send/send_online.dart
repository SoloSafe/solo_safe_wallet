import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solo_safe_wallet/screens/online_transactions/send/confirm_send_online.dart';

class SendOnlinePage extends StatefulWidget {
  final double balance = 10.0; // Assume user balance

  @override
  _SendOnlinePageState createState() => _SendOnlinePageState();
}

class _SendOnlinePageState extends State<SendOnlinePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late double maxBalance;

  @override
  void initState() {
    super.initState();
    maxBalance = widget.balance;
  }

  void _openQRScanner() async {
    String? scannedAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerPage()),
    );
    if (scannedAddress != null) {
      setState(() {
        _addressController.text = scannedAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address or Domain Name Input
              Text(
                'Address or Domain Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Enter recipient's address",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _addressController.clear();
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Clipboard.getData(Clipboard.kTextPlain).then((value) {
                            setState(() {
                              _addressController.text = value?.text ?? '';
                            });
                          });
                        },
                        child: Text('Paste'),
                      ),
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner),
                        onPressed: _openQRScanner,
                      ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recipient address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Amount Input
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: "Amount",
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        _amountController.text = maxBalance.toStringAsFixed(8);
                      });
                    },
                    child: Text('Max'),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount to send';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  if (amount > maxBalance) {
                    return 'Amount exceeds available balance';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '≈ \$${(double.tryParse(_amountController.text) ?? 0.99).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfirmSendOnlinePage(
                            asset: "USDC",
                            networkFee: 0.0001,
                            recipient: _addressController.text,
                            amount: double.parse(_amountController.text),
                            totalAmount: double.parse(_amountController.text) + 0.0001,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      // body: MobileScanner(
      //   // onDetect: (barcode, args) {
      //   //   if (barcode.rawValue != null) {
      //   //     Navigator.pop(context, barcode.rawValue); // Return scanned value
      //   //   }
      //   // },
      // ),
      body: Center(
        child: Text('QR Scanner not available'),
      ),
    );
  }
}