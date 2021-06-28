import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  static String id = 'intro_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset('images/welcome_image.png'),
            Spacer(flex: 3),
            Text('Welcome to'),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 55.0),
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 50.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Flash Chat',
                        textStyle: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                        speed: const Duration(milliseconds: 200)),
                  ],
                ),
              ],
            ),
            Spacer(),
            Text(
              'Your personal Instant Messenger app!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.64)),
            ),
            Spacer(flex: 3),
            FittedBox(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      'Continue',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(0.8),
                          ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.8),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
