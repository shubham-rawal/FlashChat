import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.isMe});
  final String text;
  final String sender;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   sender,
          //   style: TextStyle(
          //     fontSize: 12,
          //     color: Colors.black54,
          //   ),
          // ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30.0 : 0.0),
              topRight: Radius.circular(isMe ? 0.0 : 30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 3.0,
            color: isMe ? Colors.blue : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
