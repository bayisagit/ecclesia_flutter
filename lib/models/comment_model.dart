import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String text;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.text,
    required this.timestamp,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      userPhotoUrl: data['userPhotoUrl'],
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
