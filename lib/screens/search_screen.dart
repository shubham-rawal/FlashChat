import 'package:flash_chat/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

import '../constants.dart';
import 'chat_list.dart';
import 'chat_screen.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
final User user = _auth.currentUser;
String searchedUser;
String searchedEmail;
String searchedName;
String searchedUserID;
Widget finalWidget;
bool isSearchResultEmpty;

class SearchScreen extends StatefulWidget {
  static const String id = 'SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<void> searchForUser() async {
    print("SEARCHING");
    final userList = await _firestore.collection('users').get();
    for (var user in userList.docs) {
      searchedEmail = user.get('email');
      if (searchedEmail == searchedUser) {
        // searchedUser = null;
        searchedName = user.get('name');
        searchedUserID = user.get('userId');
        setState(() {
          print("Hello");

          isSearchResultEmpty = false;
        });
        print("Function $isSearchResultEmpty");
        print("Function search Name : $searchedName");
        break;
      } else {
        setState(() {
          isSearchResultEmpty = true;
        });
      }
      if (searchedName == null) {
        setState(() {
          isSearchResultEmpty = true;
        });
      }
    }
  }

  @override
  void initState() {
    finalWidget = null;
    searchedUser = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentUserDetails);
    // final _searchController = TextEditingController();

    Widget createFinalWidget() {
      if (isSearchResultEmpty == false) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () async {
                print('ListTile name : $searchedName');
                print('ListTile email : $searchedEmail');
                Map<String, String> searchedUserDetails = {
                  'searchedName': searchedName,
                  'searchedEmail': searchedEmail,
                };
                //TODO: pass searchedUserName and searchedUserId as a MAP
                //TODO: sahi se nahi horha pass abhi bhi

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
                  'id': currentUserDetails['userId'],
                  'timestamp': Timestamp.now(),
                });
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: searchedUserDetails);
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
              subtitle: Text(searchedEmail),
            ),
          ],
        );
      } else {
        return Center(
          child: Text(
            'Oops! No results found for this search. Please try again',
            textAlign: TextAlign.center,
          ),
        );
      }
    }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    // controller: _searchController,
                    onChanged: (value) {
                      searchedUser = value;
                      print(searchedUser);
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Search for a user by email...',
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      print(" searched user email $searchedUser");
                      if (searchedUser == null)
                        finalWidget = null;
                      else {
                        await searchForUser();
                        if (searchedUser == '') {
                          finalWidget = null;
                        } else
                          finalWidget = createFinalWidget();
                        // _searchController.clear();
                      }
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
            SizedBox(
              height: 30.0,
            ),
            Text('Search Results : '),
            Expanded(
              child: Container(
                child: searchedUser == null ? null : finalWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
