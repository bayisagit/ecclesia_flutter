import 'package:flutter/material.dart';
import 'home_sections/contact_section.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: SingleChildScrollView(child: ContactSection()),
    );
  }
}
