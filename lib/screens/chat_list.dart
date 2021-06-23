import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/search_screen.dart';
import 'package:flash_chat/widgets/chatListStream.dart';
import 'package:flutter/material.dart';

String name = 'Hello';
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
List<ListTile> chatTiles = [];
final User user = _auth.currentUser;
User loggedUser;

class ChatList extends StatefulWidget {
  static const String id = 'ChatList';

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  void initState() {
    getCurrentUser();
    //print(loggedInUser.email);
    //getContacts();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        print(user.uid);
      }
    } catch (e) {
      print(e);
    }
  }
//   Future<void> getContacts() async {
//     final contacts = await _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('contacts')
//         .get();
//     for (var contact in contacts.docs) {
//       var contactName = contact.get('contactName');
//       print(contact.data().toString());
//       chatTiles.add(
//         ListTile(
//           onTap: () {
//             Navigator.pushNamed(context, ChatScreen.id);
//           },
//           minVerticalPadding: 5.0,
//           contentPadding: EdgeInsets.all(10.0),
//           leading: CircleAvatar(
//             radius: 25.0,
//             backgroundColor: Colors.blueGrey.shade100,
//             child: Text(
//               contactName[0],
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//           ),
//           title: Text(
//             contactName,
//             style: TextStyle(
//               fontSize: 22,
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             size: 18,
//           ),
//         ),
//         backgroundColor: Colors.lightBlueAccent,
//         title: Text('⚡️Chats'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           )
//         ],
//       ),
//       body: ListView(
//         physics: ScrollPhysics(),
//         children: chatTiles,
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(
//           Icons.message,
//           size: 27,
//         ),
//         backgroundColor: Colors.lightBlueAccent,
//         onPressed: () {
//           Navigator.pushNamed(context, SearchScreen.id);
//         },
//       ),
//     );
//   }
// }

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
      body: SafeArea(
        child: Container(
          child: ChatListStream(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.message,
          size: 27,
        ),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.pushNamed(context, SearchScreen.id);
        },
      ),
    );
  }
}
