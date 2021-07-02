import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_list.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/roundedButton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

Map currentUserDetails = {};

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool showSpinner = false;
  String email;
  String password;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> getCurrentUserData() async {
    try {
      var dataOfCurrentUser =
          await _firestore.collection('users').doc(_auth.currentUser.uid).get();

      //print(dataOfCurrentUser.data());
      currentUserDetails = dataOfCurrentUser.data();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _text1.dispose();
    _text2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  controller: _text1,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      errorText:
                          _validateEmail ? 'Please enter your email' : null),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _text2,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      errorText: _validatePassword
                          ? 'Please enter your password'
                          : null),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  title: "Log In",
                  onPressed: () async {
                    setState(() {
                      _text1.text.isEmpty
                          ? _validateEmail = true
                          : _validateEmail = false;
                      _text2.text.isEmpty
                          ? _validatePassword = true
                          : _validatePassword = false;
                      !_validateEmail && !_validatePassword
                          ? showSpinner = true
                          : null;
                    });
                    try {
                      if (!_validateEmail && !_validatePassword) {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          await getCurrentUserData();
                          //print(currentUserDetails);
                          Navigator.pushNamed(context, ChatList.id);
                        }

                        setState(() {
                          showSpinner = false;
                          final snackBar = SnackBar(
                            duration: Duration(milliseconds: 1000),
                            content: Text('Logged in as $email'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    } catch (error) {
                      print(error.message);
                      setState(() {
                        showSpinner = false;
                      });

                      bool isNewUser = false;
                      if (error.code == 'user-not-found') isNewUser = true;

                      final snackbar = SnackBar(
                        content: Text(isNewUser
                            ? 'No account found, Register Now!'
                            : error.message),
                        action: SnackBarAction(
                            label: isNewUser ? 'Register' : 'OK',
                            onPressed: isNewUser
                                ? () {
                                    Navigator.pushNamed(
                                        context, RegistrationScreen.id);
                                  }
                                : () {}),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
