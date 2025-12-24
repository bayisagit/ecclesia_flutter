import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'user' or 'admin'
  final String? photoUrl;
  final DateTime? lastSeenPostDate;
  final Map<String, DateTime> lastViewedMinistries;
  final DateTime? lastViewedSermons;
  final DateTime? lastViewedEvents;

  UserModel({
    required this.uid,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    required this.role,
    this.photoUrl,
    this.lastSeenPostDate,
    this.lastViewedMinistries = const {},
    this.lastViewedSermons,
    this.lastViewedEvents,
  });

  // Create a UserModel from a Map (e.g. from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? 'user',
      photoUrl: data['photoUrl'],
      lastSeenPostDate: data['lastSeenPostDate'] != null
          ? (data['lastSeenPostDate'] as Timestamp).toDate()
          : null,
      lastViewedMinistries:
          (data['lastViewedMinistries'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as Timestamp).toDate()),
          ) ??
          {},
      lastViewedSermons: data['lastViewedSermons'] != null
          ? (data['lastViewedSermons'] as Timestamp).toDate()
          : null,
      lastViewedEvents: data['lastViewedEvents'] != null
          ? (data['lastViewedEvents'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert UserModel to a Map (e.g. for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'photoUrl': photoUrl,
      'lastSeenPostDate': lastSeenPostDate,
      'lastViewedMinistries': lastViewedMinistries,
      'lastViewedSermons': lastViewedSermons,
      'lastViewedEvents': lastViewedEvents,
    };
  }
}
