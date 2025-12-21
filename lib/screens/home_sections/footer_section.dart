import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  final Function(String sectionKey)? onScrollToSection;

  const FooterSection({Key? key, this.onScrollToSection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF111111),
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [
          Text(
            'Ecclesia',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '123 Church Street, City, Country',
            style: TextStyle(color: Colors.grey[500]),
          ),
          Text(
            'Phone: (123) 456-7890  |  Email: info@ecclesia.com',
            style: TextStyle(color: Colors.grey[500]),
          ),
          SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildFooterLink('HOME', 'home'),
              _buildFooterLink('ABOUT US', 'about'),
              _buildFooterLink('SERMONS', 'sermons'),
              _buildFooterLink('EVENTS', 'events'),
              _buildFooterLink('CONTACT', 'contact'),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(Icons.facebook),
              SizedBox(width: 15),
              _buildSocialIcon(Icons.camera_alt), // Instagram placeholder
              SizedBox(width: 15),
              _buildSocialIcon(Icons.ondemand_video), // YouTube placeholder
            ],
          ),
          SizedBox(height: 30),
          Divider(color: Colors.grey[800]),
          SizedBox(height: 20),
          Text(
            '© 2025 Ecclesia Church. All Rights Reserved.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, String key) {
    return TextButton(
      onPressed: () {
        if (onScrollToSection != null) {
          onScrollToSection!(key);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
