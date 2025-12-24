import 'package:cloud_firestore/cloud_firestore.dart';

class MinistryPostModel {
  final String id;
  final String ministryName; // e.g., 'Worship Team', 'Outreach Team'
  final String title;
  final String content;
  final String imageUrl;
  final List<String> imageUrls;
  final String audioUrl; // For Bible Study
  final DateTime date;
  final String type; // 'general', 'mission', 'devotional', 'event'
  final int likes;
  final List<String> likedBy;
  final int views;
  final int commentCount;

  // Mission Stats
  final int? heardCount;
  final int? hopeCount;
  final int? believedCount;

  MinistryPostModel({
    required this.id,
    required this.ministryName,
    required this.title,
    required this.content,
    required this.date,
    this.imageUrl = '',
    this.imageUrls = const [],
    this.audioUrl = '',
    this.type = 'general',
    this.likes = 0,
    this.likedBy = const [],
    this.views = 0,
    this.commentCount = 0,
    this.heardCount,
    this.hopeCount,
    this.believedCount,
  });

  factory MinistryPostModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return MinistryPostModel(
      id: doc.id,
      ministryName: data['ministryName'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      audioUrl: data['audioUrl'] ?? '',
      views: data['views'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      date: (data['date'] as Timestamp).toDate(),
      type: data['type'] ?? 'general',
      heardCount: data['heardCount'],
      hopeCount: data['hopeCount'],
      believedCount: data['believedCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ministryName': ministryName,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'audioUrl': audioUrl,
      'date': date,
      'type': type,
      'views': views,
      'commentCount': commentCount,
      'likes': likes,
      'likedBy': likedBy,
      'heardCount': heardCount,
      'hopeCount': hopeCount,
      'believedCount': believedCount,
    };
  }
}
