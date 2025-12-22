import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';
import 'verify_email_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // Return either Home or Welcome widget
    if (user == null) {
      return WelcomeScreen();
    } else if (!user.emailVerified) {
      return VerifyEmailScreen();
    } else {
      return HomeScreen();
    }
  }
}
