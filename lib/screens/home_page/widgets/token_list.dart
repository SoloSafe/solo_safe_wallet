import 'package:flutter/material.dart';

class TokenListWidget extends StatefulWidget {
  final List<String> tokens;

  TokenListWidget({required this.tokens});

  @override
  _TokenListWidgetState createState() => _TokenListWidgetState();
}

class _TokenListWidgetState extends State<TokenListWidget> {
  int? _selectedTokenIndex; // Track the currently selected token

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildTokenList(),
    );
  }

  // Build the list of tokens with dots in between
  List<Widget> _buildTokenList() {
    List<Widget> tokenWidgets = [];

    for (int i = 0; i < widget.tokens.length; i++) {
      // Add a dot between tokens
      if (i > 0) {
        tokenWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.brightness_1,
              size: 5, // Small dot size
              color: Colors.grey,
            ),
          ),
        );
      }

      tokenWidgets.add(
        GestureDetector(
          onTap: () {
            // If the same token is clicked, do nothing
            if (_selectedTokenIndex != i) {
              setState(() {
                _selectedTokenIndex = i; // Update selected token
              });
            }
          },
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: TextStyle(// Enlarge selected token
              color: _selectedTokenIndex == i
                  ? Colors.blue // Blue color when selected
                  : Colors.black, // Default color when not selected
              fontWeight: _selectedTokenIndex == i
                  ? FontWeight.bold // Bold font when selected
                  : FontWeight.normal, // Normal font when not selected
            ),
            child: Text(widget.tokens[i]),
          ),
        ),
      );
    }

    return tokenWidgets;
  }
}