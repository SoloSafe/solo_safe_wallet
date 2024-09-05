import 'package:flutter/material.dart';

class SendReceive extends StatelessWidget{
  final String send_type;

  SendReceive({required this.send_type});

  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Send"),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Receive"),
          ),
        ),
      ],),
    );
  }
}