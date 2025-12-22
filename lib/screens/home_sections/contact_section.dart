import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

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
          _buildContactCard(
            context,
            Icons.location_on,
            'Address',
            'akaki quality 1/3, AASTU, Addis Ababa, Ethiopia',
            null,
          ),
          SizedBox(height: 15),
          _buildContactCard(
            context,
            Icons.phone,
            'Phone',
            '+251 949434281',
            'tel:+251911234567',
          ),
          SizedBox(height: 15),
          _buildContactCard(
            context,
            Icons.email,
            'Email',
            'contact@aastufocus.org',
            'mailto:contact@aastufocus.org',
          ),
          SizedBox(height: 40),
          Text('Follow Us', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 20),
          _buildSocialButton(
            context,
            FontAwesomeIcons.telegram,
            'Telegram',
            'https://t.me/fstufocus',
            Colors.blue,
          ),
          SizedBox(height: 15),
          _buildSocialButton(
            context,
            FontAwesomeIcons.facebook,
            'Facebook',
            'https://www.facebook.com/fstufocus',
            Colors.blue[800]!,
          ),
          SizedBox(height: 15),
          _buildSocialButton(
            context,
            FontAwesomeIcons.tiktok,
            'TikTok',
            'https://www.tiktok.com/@aastu_focus?_t=ZM-8zH2lbVuAZK&_r=1',
            Colors.black,
          ),
          SizedBox(height: 15),
          _buildSocialButton(
            context,
            FontAwesomeIcons.youtube,
            'YouTube',
            'https://youtube.com/@aastufocusofficial9025?si=-59Bns0AXOcltSrV',
            Colors.red,
          ),
          SizedBox(height: 15),
          _buildSocialButton(
            context,
            FontAwesomeIcons.instagram,
            'Instagram',
            'https://www.instagram.com/aastufocus/?igsh=MzNlNGNkZWQ4Mg%3D%3D',
            Colors.purple,
          ),
          SizedBox(height: 40),
          Divider(),
          SizedBox(height: 20),
          Center(
            child: Text(
              '© 2025 AASTU Focus Fellowship. All Rights Reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    IconData icon,
    String title,
    String content,
    String? url,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: url != null ? () => _launchUrl(url) : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.blueAccent : Colors.black12,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
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
            ),
            if (url != null)
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    String url,
    Color iconColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Adjust icon color for dark mode if it's black (like TikTok)
    final effectiveIconColor = (isDark && iconColor == Colors.black)
        ? Colors.white
        : iconColor;

    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.blueAccent : Colors.black12,
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: effectiveIconColor, size: 24),
            SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(Icons.arrow_outward, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
