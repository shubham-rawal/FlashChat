import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'chat_screen.dart';

class SearchScreen extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String id = 'SearchScreen';
  String searchedUser;
  String searchedEmail;
  String searchedName;
  List<ListTile> searchResult = [];

  Future<Widget> searchForUser() async {
    final userList = await _firestore.collection('users').get();
    for (var user in userList.docs) {
      searchedEmail = user.get('email');
      if (searchedEmail == searchedUser) {
        searchedName = user.get('name');
        print(searchedName);
        searchResult.add(
          ListTile(
            onTap: () {
              //Navigator.pushNamed(context, ChatScreen.id);
            },
            minVerticalPadding: 5.0,
            contentPadding: EdgeInsets.all(10.0),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.blueGrey.shade100,
              child: Text(
                searchedName[0],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            title: Text(
              searchedName,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Search 🔍'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    onChanged: (value) {
                      searchedUser = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Search for a user by email...',
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      searchForUser();
                    },
                    child: CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 50.0,),
            searchResult[0],
          ],
        ),
      ),
    );
  }
}
