import 'package:flutter/material.dart';
import 'home_sections/contact_section.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: SingleChildScrollView(child: ContactSection()),
    );
  }
}
