import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/widgets/roundedButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registerationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _text1 = TextEditingController();
  final _text2 = TextEditingController();
  final _text3 = TextEditingController();
  bool _validate1 = false, _validate2 = false, _validate3 = false;
  bool showSpinner = false;
  String name;
  String email;
  String password;
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
                  onChanged: (value) {
                    name = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your name',
                      errorText: _validate1 ? 'Please enter your name.' : null),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _text2,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email',
                      errorText: _validate2 ? 'Please enter an email.' : null),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: _text3,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Create a password',
                      errorText:
                          _validate3 ? 'Please create a password.' : null),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  
                  color: Colors.blueAccent,
                  title: "Register",
                  onPressed: () async {
                    setState(() {
                      _text1.text.isEmpty
                          ? _validate1 = true
                          : _validate1 = false;
                      _text2.text.isEmpty
                          ? _validate2 = true
                          : _validate2 = false;
                      _text3.text.isEmpty
                          ? _validate3 = true
                          : _validate3 = false;
                      !_validate1 && !_validate2 && !_validate3
                          ? showSpinner = true
                          : null;
                    });
                    try {
                      if (!_validate1 && !_validate2 && !_validate3) {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    } catch (error) {
                      setState(() {
                        showSpinner = false;
                      });
                      final snackbar = SnackBar(
                        content: Text(error.message),
                        action: SnackBarAction(label: 'OK', onPressed: () {}),
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
