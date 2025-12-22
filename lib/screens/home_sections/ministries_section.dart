import 'package:flutter/material.dart';
import '../ministry_details_screen.dart';

class MinistriesSection extends StatelessWidget {
  const MinistriesSection({super.key});

  final List<Map<String, String>> _ministries = const [
    {'title': 'Worship Team', 'image': 'assets/images/worship_team.png'},
    {'title': 'Prayer Team', 'image': 'assets/images/prayer_team.png'},
    {'title': 'Outreach Team', 'image': 'assets/images/outreach_team.png'},
    {
      'title': 'Bible Study Team',
      'image': 'assets/images/bible_study_team.png',
    },
    {'title': 'Welcome Team', 'image': 'assets/images/welcome_team.png'},
    {'title': 'Media Team', 'image': 'assets/images/media_team.png'},
    {'title': 'Ebenezer Team', 'image': 'assets/images/ebenezer_team.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Text(
            'OUR MINISTRIES',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Serve and be served',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 40),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _ministries.length,
            separatorBuilder: (context, index) => SizedBox(height: 20),
            itemBuilder: (context, index) {
              return _buildMinistryCard(
                context,
                _ministries[index]['title']!,
                _ministries[index]['image']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMinistryCard(
    BuildContext context,
    String title,
    String imageUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MinistryDetailsScreen(ministryName: title, imageUrl: imageUrl),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
