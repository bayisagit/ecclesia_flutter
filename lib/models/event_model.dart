import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String createdBy;
  final String imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.createdBy,
    this.imageUrl = '',
  });

  // Create an EventModel from a Firestore Document
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      // Handle Timestamp from Firestore
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert EventModel to a Map for saving
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'createdBy': createdBy,
      'imageUrl': imageUrl,
    };
  }
}
