import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/event_model.dart';
import '../models/sermon_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get Events Stream
  Stream<List<EventModel>> get events {
    return _db.collection('events').orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    });
  }

  // Get Sermons Stream
  Stream<List<SermonModel>> get sermons {
    return _db
        .collection('sermons')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SermonModel.fromFirestore(doc))
              .toList();
        });
  }

  // Add Event (Admin only)
  Future<void> addEvent(
    String title,
    String description,
    DateTime date,
    String location,
    String uid,
    String imageUrl,
  ) async {
    await _db.collection('events').add({
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'createdBy': uid,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Add Sermon (Admin only)
  Future<void> addSermon(
    String title,
    String speaker,
    DateTime date,
    String imageUrl,
    String videoUrl,
  ) async {
    await _db.collection('sermons').add({
      'title': title,
      'speaker': speaker,
      'date': date,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Seed Sample Sermons
  Future<void> seedSermons() async {
    final List<Map<String, dynamic>> sampleSermons = [
      {
        'title': 'The Power of Faith',
        'speaker': 'Pastor John Doe',
        'date': DateTime.now().subtract(Duration(days: 2)),
        'imageUrl':
            'https://images.unsplash.com/photo-1507692049790-de58293a469d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      },
      {
        'title': 'Walking in Love',
        'speaker': 'Pastor Jane Smith',
        'date': DateTime.now().subtract(Duration(days: 9)),
        'imageUrl':
            'https://images.unsplash.com/photo-1510936111840-65e151ad71bb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      },
      {
        'title': 'Finding Peace',
        'speaker': 'Pastor Michael Brown',
        'date': DateTime.now().subtract(Duration(days: 16)),
        'imageUrl':
            'https://images.unsplash.com/photo-1548625149-fc4a29cf7092?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
        'videoUrl': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      },
    ];

    for (var data in sampleSermons) {
      await _db.collection('sermons').add(data);
    }
  }

  // Seed Sample Events
  Future<void> seedEvents() async {
    final List<Map<String, dynamic>> sampleEvents = [
      {
        'title': 'Sunday Worship Service',
        'description': 'Join us for a time of worship and the word.',
        'date': DateTime.now().add(Duration(days: 2, hours: 4)),
        'location': 'Main Sanctuary',
        'createdBy': 'admin',
      },
      {
        'title': 'Youth Bible Study',
        'description': 'Deep dive into the scriptures for teens.',
        'date': DateTime.now().add(Duration(days: 4, hours: 12)),
        'location': 'Youth Hall',
        'createdBy': 'admin',
      },
      {
        'title': 'Community Outreach',
        'description': 'Serving our neighbors with love.',
        'date': DateTime.now().add(Duration(days: 7, hours: 3)),
        'location': 'City Park',
        'createdBy': 'admin',
      },
      {
        'title': 'Worship Night',
        'description': 'An evening of praise and worship.',
        'date': DateTime.now().add(Duration(days: 10, hours: 13)),
        'location': 'Main Sanctuary',
        'createdBy': 'admin',
      },
    ];

    for (var data in sampleEvents) {
      await _db.collection('events').add(data);
    }
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    await _db.collection('events').doc(eventId).delete();
  }

  // Add Reaction
  Future<void> addReaction(String eventId, String userId, String type) async {
    await _db
        .collection('events')
        .doc(eventId)
        .collection('reactions')
        .doc(userId)
        .set({'userId': userId, 'type': type});
  }

  // Send Feedback
  Future<void> sendFeedback(String uid, String email, String message) async {
    await _db.collection('feedback').add({
      'uid': uid,
      'email': email,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get Feedback Stream (Admin only)
  Stream<QuerySnapshot> get feedbackStream {
    return _db
        .collection('feedback')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Upload Profile Image
  Future<String?> uploadProfileImage(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child('profile_images/$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Update User Photo URL
  Future<void> updateUserPhoto(String uid, String photoUrl) async {
    await _db.collection('users').doc(uid).update({'photoUrl': photoUrl});
  }

  // Get User Data Stream
  Stream<UserModel> getUserData(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, uid);
      } else {
        // Return a default user model or handle empty doc
        return UserModel(uid: uid, email: '', role: 'user');
      }
    });
  }
}
