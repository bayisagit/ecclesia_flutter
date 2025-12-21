import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/database_service.dart';
import '../../models/sermon_model.dart';
import '../video_player_screen.dart';

class SermonsSection extends StatelessWidget {
  const SermonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LATEST SERMONS',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 3,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: Text('VIEW ALL ARCHIVE')),
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
              final sermons = snapshot.data ?? [];
              if (sermons.isEmpty) {
                return Text('No sermons available.');
              }
              return Column(
                children: sermons
                    .map((sermon) => _buildSermonCard(context, sermon))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSermonCard(BuildContext context, SermonModel sermon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                sermon.imageUrl.isNotEmpty
                    ? sermon.imageUrl
                    : 'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60', // Fallback image
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${sermon.speaker}  |  ${DateFormat('MMM d, yyyy').format(sermon.date)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.headset, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('Audio', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 15),
                      Icon(Icons.videocam, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('Video', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 15),
                      Icon(Icons.download, size: 16, color: Colors.grey),
                      SizedBox(width: 5),
                      Text('PDF', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.play_circle_fill,
                size: 40,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No video URL available')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
