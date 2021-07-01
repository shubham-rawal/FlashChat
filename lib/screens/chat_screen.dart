import 'package:flash_chat/screens/search_screen.dart';
import 'package:flash_chat/widgets/chatListStream.dart';
import 'package:flash_chat/widgets/messagesStream.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_list.dart';
import 'login_screen.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String chatEmail =
        ModalRoute.of(context).settings.arguments as String;
    print(chatEmail);
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
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
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(chatEmail),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      messageTextController.clear();

                      //We need messageText + loggedInUser.email to upload to firestore
                      if (messageText.isNotEmpty && messageText != '') {
                        await _firestore
                            .collection('users')
                            .doc(loggedUser.uid)
                            .collection('contacts')
                            .doc(searchedUserID)
                            .set({
                          'contactEmail': searchedEmail,
                          'contactName': searchedName,
                          'id': searchedUserID,
                          'timestamp': Timestamp.now(),
                        });

                        await _firestore
                            .collection('users')
                            .doc(searchedUserID)
                            .collection('contacts')
                            .doc(currentUserDetails['userId'])
                            .set({
                          'contactEmail': loggedUser.email,
                          'contactName': currentUserDetails['name'],
                          'Id': currentUserDetails['userId'],
                          'timestamp': Timestamp.now(),
                        });

                        await _firestore.collection('messages').add({
                          'timestamp': Timestamp.now(),
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'receiver': chatEmail,
                        });
                        messageText = null;
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
