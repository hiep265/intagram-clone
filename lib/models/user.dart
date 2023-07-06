import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String imageUrl;
  final String username;
  final String bio;
  final String uid;
  final List followers;
  final List following;
  User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.imageUrl,
      required this.bio,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJsong() => {
        'email': email,
        'uid': uid,
        'username': username,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photourl': imageUrl
      };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        uid: snapshot['uid'],
        email: snapshot['email'],
        imageUrl: snapshot['photourl'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}
