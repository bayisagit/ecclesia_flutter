import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';
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
    final firebaseUser = Provider.of<User?>(context);

    return StreamBuilder<UserModel>(
      stream: firebaseUser != null
          ? DatabaseService().getUserData(firebaseUser.uid)
          : Stream.value(UserModel(uid: '', email: '', role: 'user')),
      builder: (context, snapshot) {
        final userModel = snapshot.data;

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
                    userModel,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMinistryCard(
    BuildContext context,
    String title,
    String imageUrl,
    UserModel? user,
  ) {
    return GestureDetector(
      onTap: () {
        if (user != null && user.uid.isNotEmpty) {
          DatabaseService().updateLastViewed(
            user.uid,
            'ministries',
            ministryName: title,
          );
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                MinistryDetailsScreen(ministryName: title, imageUrl: imageUrl),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
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
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
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
          if (user != null && user.uid.isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: StreamBuilder<int>(
                stream: DatabaseService().getUnseenMinistryPostsCount(
                  title,
                  user.lastViewedMinistries[title],
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == 0) {
                    return SizedBox.shrink();
                  }
                  return Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
