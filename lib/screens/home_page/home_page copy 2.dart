import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<HomePage> {
  double _onlineBalance = 13956.85;
  double _offlineBalance = 175.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Balance Display with Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C43CE), Color(0xFF916CD8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50), // Padding from top of screen
                Text(
                  "OnBalance",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${_onlineBalance.toStringAsFixed(2)} STRK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.white38,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                Text(
                  "OffBalance",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${_offlineBalance.toStringAsFixed(2)} STRK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 30),
                // Action Buttons (Send, Receive, History)
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(Icons.send, "Send"),
                        _buildActionButton(Icons.qr_code, "Receive"),
                        _buildActionButton(Icons.history, "History"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Recent Transactions Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Your latest transactions",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full transaction history
                  },
                  child: Text("View all >"),
                ),
              ],
            ),
          ),
          // Recent Transactions List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 5, // Dummy count for now
              itemBuilder: (context, index) {
                // Dummy transaction data
                bool isPositive = index % 2 == 0;
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  leading: Text(
                    "${isPositive ? "+" : "-"}234 USDT",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    "${isPositive ? 'From' : 'To'} 0x3478...4743",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    "2h",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation between pages
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Transfer",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
            
          ),
        ],
      ),
    );
  }

  // Helper method to create action buttons
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.purple,
          size: 30,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}