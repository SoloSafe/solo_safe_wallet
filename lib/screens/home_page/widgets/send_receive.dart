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
            onPressed: () {
              if(send_type == "online"){
                Navigator.pushNamed(context, '/send_online');
              }else {
                Navigator.pushNamed(context, '/send_offline');
              }
            },
            child: Text("Send", style: TextStyle(color: Colors.black87)),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if(send_type == "online"){
                Navigator.pushNamed(context, '/receive_online');
              } else {
                Navigator.pushNamed(context, '/receive_offline');
              }
            },
            child: Text("Receive", style: TextStyle(color: Colors.black87)),
          ),
        ),
      ],),
    );
  }
}