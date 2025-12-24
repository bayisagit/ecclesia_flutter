import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:cloudinary_public/cloudinary_public.dart';
import '../models/event_model.dart';
import '../models/sermon_model.dart';
import '../models/user_model.dart';
import '../models/ministry_post_model.dart';
import '../models/comment_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final CloudinaryPublic _cloudinary = CloudinaryPublic(
    'doz1fanub',
    'aastufocus',
    cache: false,
  );

  // Get Ministry Posts Stream
  Stream<List<MinistryPostModel>> getMinistryPosts(String ministryName) {
    return _db
        .collection('ministry_posts')
        .where('ministryName', isEqualTo: ministryName)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MinistryPostModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get Annual Verses Stream
  Stream<List<MinistryPostModel>> getAnnualVerses() {
    return _db
        .collection('ministry_posts')
        .where('type', isEqualTo: 'annual_verse')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MinistryPostModel.fromFirestore(doc))
              .toList();
        });
  }

  // Get Devotional Posts Stream
  Stream<List<MinistryPostModel>> getDevotionalPosts() {
    return _db
        .collection('ministry_posts')
        .where('type', isEqualTo: 'devotional')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MinistryPostModel.fromFirestore(doc))
              .toList();
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

  // Delete Sermon (Admin only)
  Future<void> deleteSermon(String sermonId) async {
    await _db.collection('sermons').doc(sermonId).delete();
  }

  // Get Events Stream
  Stream<List<EventModel>> get events {
    return _db.collection('events').orderBy('date').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    });
  }

  // Add Ministry Post (Admin only)
  Future<void> addMinistryPost(MinistryPostModel post) async {
    await _db.collection('ministry_posts').add(post.toMap());
  }

  // Delete Ministry Post (Admin only)
  Future<void> deleteMinistryPost(String postId) async {
    await _db.collection('ministry_posts').doc(postId).delete();
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
      'likes': [],
      'interested': [],
      'going': [],
    });
  }

  // Toggle Event Reaction
  Future<void> toggleEventReaction(
    String eventId,
    String userId,
    String reactionType,
  ) async {
    final docRef = _db.collection('events').doc(eventId);
    final doc = await docRef.get();
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final List<dynamic> currentReactions = data[reactionType] ?? [];

    if (currentReactions.contains(userId)) {
      await docRef.update({
        reactionType: FieldValue.arrayRemove([userId]),
      });
    } else {
      await docRef.update({
        reactionType: FieldValue.arrayUnion([userId]),
      });
    }
  }

  // Update Last Viewed
  Future<void> updateLastViewed(
    String uid,
    String category, {
    String? ministryName,
  }) async {
    final docRef = _db.collection('users').doc(uid);
    if (category == 'ministries' && ministryName != null) {
      await docRef.update({
        'lastViewedMinistries.$ministryName': FieldValue.serverTimestamp(),
      });
    } else if (category == 'sermons') {
      await docRef.update({'lastViewedSermons': FieldValue.serverTimestamp()});
    } else if (category == 'events') {
      await docRef.update({'lastViewedEvents': FieldValue.serverTimestamp()});
    }
  }

  // Get Unseen Ministry Posts Count
  Stream<int> getUnseenMinistryPostsCount(
    String ministryName,
    DateTime? lastViewed,
  ) {
    Query query = _db
        .collection('ministry_posts')
        .where('ministryName', isEqualTo: ministryName);

    if (lastViewed != null) {
      query = query.where('date', isGreaterThan: lastViewed);
    }

    return query.snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Get Unseen Sermons Count
  Stream<int> getUnseenSermonsCount(DateTime? lastViewed) {
    Query query = _db.collection('sermons');

    if (lastViewed != null) {
      query = query.where('date', isGreaterThan: lastViewed);
    }

    return query.snapshots().map((snapshot) => snapshot.docs.length);
  }

  // Get Unseen Events Count
  Stream<int> getUnseenEventsCount(DateTime? lastViewed) {
    Query query = _db.collection('events');

    if (lastViewed != null) {
      query = query.where('date', isGreaterThan: lastViewed);
    }

    return query.snapshots().map((snapshot) => snapshot.docs.length);
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
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'profile_images',
          publicId: '${uid}_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint('Cloudinary Upload Error: $e');
      return null;
    }
  }

  // Upload General Image
  Future<String?> uploadImage(File imageFile, String folderName) async {
    try {
      CloudinaryResponse response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: folderName,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      debugPrint('Cloudinary Upload Error: $e');
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

  // Toggle Like on Ministry Post
  Future<void> toggleLike(String postId, String userId, bool isLiked) async {
    final docRef = _db.collection('ministry_posts').doc(postId);

    if (isLiked) {
      // Unlike
      await docRef.update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      // Like
      await docRef.update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // Increment View Count
  Future<void> incrementView(String postId) async {
    await _db.collection('ministry_posts').doc(postId).update({
      'views': FieldValue.increment(1),
    });
  }

  // Get Comments Stream
  Stream<List<CommentModel>> getComments(String postId) {
    return _db
        .collection('ministry_posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CommentModel.fromFirestore(doc))
              .toList();
        });
  }

  // Add Comment
  Future<void> addComment(String postId, CommentModel comment) async {
    final postRef = _db.collection('ministry_posts').doc(postId);
    final commentRef = postRef.collection('comments').doc();

    await _db.runTransaction((transaction) async {
      transaction.set(commentRef, comment.toMap());
      transaction.update(postRef, {'commentCount': FieldValue.increment(1)});
    });
  }

  // Get All Users (Admin only)
  Stream<List<UserModel>> get users {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Delete User (Admin only)
  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // Update User Role (Admin only)
  Future<void> updateUserRole(String uid, String newRole) async {
    await _db.collection('users').doc(uid).update({'role': newRole});
  }

  // Update Last Seen Post Date
  Future<void> updateLastSeenPostDate(String uid) async {
    await _db.collection('users').doc(uid).update({
      'lastSeenPostDate': FieldValue.serverTimestamp(),
    });
  }
}
