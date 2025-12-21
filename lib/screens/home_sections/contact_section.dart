import 'package:flutter/material.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Us', style: Theme.of(context).textTheme.displayMedium),
          SizedBox(height: 30),
          _buildContactInfo(
            context,
            Icons.location_on,
            'Address',
            '123 Church Street, City, Country',
          ),
          SizedBox(height: 20),
          _buildContactInfo(context, Icons.phone, 'Phone', '(123) 456-7890'),
          SizedBox(height: 20),
          _buildContactInfo(context, Icons.email, 'Email', 'info@ecclesia.com'),
          SizedBox(height: 40),
          Text('Follow Us', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 20),
          Row(
            children: [
              _buildSocialIcon(context, Icons.facebook),
              SizedBox(width: 20),
              _buildSocialIcon(context, Icons.camera_alt),
              SizedBox(width: 20),
              _buildSocialIcon(context, Icons.ondemand_video),
            ],
          ),
          SizedBox(height: 40),
          Divider(),
          SizedBox(height: 20),
          Center(
            child: Text(
              '© 2025 Ecclesia Church. All Rights Reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(
    BuildContext context,
    IconData icon,
    String title,
    String content,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 24),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
        size: 24,
      ),
    );
  }
}
