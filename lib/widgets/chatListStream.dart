import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_list.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
String contactName;
String contactEmail;

class ChatListStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(loggedUser.uid)
            .collection('contacts')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          //print('snapshot data ${snapshot.data.docs[2].get('contactName')}');
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          }
          final contactDetails = snapshot.data.docs.reversed;
          print(contactDetails.length);
          List<ListTile> chatTiles = [];
          for (var contactDetail in contactDetails) {
            contactName = contactDetail.get('contactName');
            contactEmail = contactDetail.get('contactEmail');
            print(contactEmail);
            chatTiles.add(
              ListTile(
                onTap: () {
                  //print(contactEmail);
                  Navigator.pushNamed(context, ChatScreen.id,
                      arguments: contactEmail);
                },
                minVerticalPadding: 5.0,
                contentPadding: EdgeInsets.all(10.0),
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundColor: Colors.blueGrey.shade100,
                  child: Text(
                    contactName[0],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                title: Text(
                  contactName,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                subtitle: Text(
                  contactEmail,
                ),
              ),
            );
          }
          if (chatTiles.isEmpty) {
            return Center(
              child: Text(
                'No chats to be displayed. Start a new chat by tapping on the 💬 button below!',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(10.0),
                    physics: ScrollPhysics(),
                    children: chatTiles,
                  ),
                ),
              ],
            );
          }
        });
  }
}
