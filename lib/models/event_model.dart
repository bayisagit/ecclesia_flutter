import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String createdBy;
  final String imageUrl;
  final List<String> likes;
  final List<String> interested;
  final List<String> going;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.createdBy,
    this.imageUrl = '',
    this.likes = const [],
    this.interested = const [],
    this.going = const [],
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
      likes: List<String>.from(data['likes'] ?? []),
      interested: List<String>.from(data['interested'] ?? []),
      going: List<String>.from(data['going'] ?? []),
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
      'likes': likes,
      'interested': interested,
      'going': going,
    };
  }
}
