import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_list.dart';
import 'package:flash_chat/screens/search_screen.dart';
import 'package:flash_chat/widgets/chatListStream.dart';
import 'package:flash_chat/widgets/messageBubbles.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/chat_screen.dart';

class MessagesStream extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;
  final String email;
  MessagesStream(this.email);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final messageReceiver = message.get('receiver');
          final currentUser = loggedInUser.email;
          //print(email);
          if ((messageSender == currentUser && messageReceiver == email) || (messageSender == email && messageReceiver == currentUser)) {
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            physics: ScrollPhysics(),
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
