class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'user' or 'admin'
  final String? photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    required this.role,
    this.photoUrl,
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
    };
  }
}
