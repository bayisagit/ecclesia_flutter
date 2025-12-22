import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecclesia_flutter/models/user_model.dart';
import '../../services/database_service.dart';
import '../../models/sermon_model.dart';
import '../video_player_screen.dart';

class SermonsSection extends StatefulWidget {
  const SermonsSection({super.key});

  @override
  State<SermonsSection> createState() => _SermonsSectionState();
}

class _SermonsSectionState extends State<SermonsSection> {
  bool _showArchive = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showArchive = false;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'LATEST SERMONS',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontSize: !_showArchive ? 24 : 14,
                                fontWeight: FontWeight.bold,
                                color: !_showArchive
                                    ? null
                                    : Theme.of(context).disabledColor,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
                      SizedBox(height: 5),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: !_showArchive ? 50 : 0,
                        height: 3,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showArchive = true;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'SERMON ARCHIVE',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                fontSize: _showArchive ? 24 : 14,
                                fontWeight: FontWeight.bold,
                                color: _showArchive
                                    ? null
                                    : Theme.of(context).disabledColor,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ),
                      SizedBox(height: 5),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _showArchive ? 50 : 0,
                        height: 3,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          StreamBuilder<List<SermonModel>>(
            stream: DatabaseService().sermons,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error loading sermons');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final allSermons = snapshot.data ?? [];
              if (allSermons.isEmpty) {
                return Text('No sermons available.');
              }

              List<SermonModel> displayedSermons;
              if (_showArchive) {
                displayedSermons = allSermons;
              } else {
                displayedSermons = allSermons.take(10).toList();
              }

              final user = FirebaseAuth.instance.currentUser;
              return StreamBuilder<UserModel>(
                stream: user != null
                    ? DatabaseService().getUserData(user.uid)
                    : Stream.value(UserModel(uid: '', email: '', role: 'user')),
                builder: (context, userSnapshot) {
                  final isAdmin = userSnapshot.data?.role == 'admin';
                  return Column(
                    children: displayedSermons
                        .map(
                          (sermon) =>
                              _buildSermonCard(context, sermon, isAdmin),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSermonCard(
    BuildContext context,
    SermonModel sermon,
    bool isAdmin,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              if (sermon.videoUrl.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      videoUrl: sermon.videoUrl,
                      title: sermon.title,
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: sermon.imageUrl.isNotEmpty
                        ? (sermon.imageUrl.startsWith('http')
                              ? Image.network(
                                  sermon.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported),
                                      ),
                                )
                              : Image.asset(
                                  sermon.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.image_not_supported),
                                      ),
                                ))
                        : Image.network(
                            'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60', // Fallback image
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.image_not_supported),
                                ),
                          ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sermon.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          sermon.speaker,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('MMM d, yyyy').format(sermon.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_circle_outline,
                    size: 40,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          if (isAdmin)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Sermon'),
                        content: Text(
                          'Are you sure you want to delete this sermon?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await DatabaseService().deleteSermon(sermon.id);
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
