import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

String name = 'Hello';

class ChatList extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String id = 'ChatList';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
        title: Text('⚡️Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.id);
            },
            minVerticalPadding: 5.0,
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.blueGrey.shade100,
              child: Text(
                name[0],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message,
          size: 27,
        ),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {},
      ),
    );
  }
}
