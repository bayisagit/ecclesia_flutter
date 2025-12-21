import 'package:cloud_firestore/cloud_firestore.dart';

class SermonModel {
  final String id;
  final String title;
  final String speaker;
  final DateTime date;
  final String imageUrl;
  final String videoUrl;

  SermonModel({
    required this.id,
    required this.title,
    required this.speaker,
    required this.date,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory SermonModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SermonModel(
      id: doc.id,
      title: data['title'] ?? '',
      speaker: data['speaker'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
    );
  }
}
