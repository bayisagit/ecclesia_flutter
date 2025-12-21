class UserModel {
  final String uid;
  final String email;
  final String role; // 'user' or 'admin'
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  // Create a UserModel from a Map (e.g. from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      photoUrl: data['photoUrl'],
    );
  }

  // Convert UserModel to a Map (e.g. for saving to Firestore)
  Map<String, dynamic> toMap() {
    return {'email': email, 'role': role, 'photoUrl': photoUrl};
  }
}
