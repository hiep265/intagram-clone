import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String postUrl;
  final String username;
  final String postId;
  final String uid;
  final DateTime datePublished;
  final String profImage;
  final like;
  Post(
      {required this.username,
      required this.uid,
      required this.description,
      required this.postId,
      required this.postUrl,
      required this.datePublished,
      required this.like,
      required this.profImage});
  Map<String, dynamic> toJsong() => {
        'description': description,
        'uid': uid,
        'username': username,
        'postId': postId,
        'postUrl': postUrl,
        'datePublished': datePublished,
        'like': like,
        'profImage': profImage
      };
  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        description: snapshot['description'],
        postId: snapshot['postId'],
        postUrl: snapshot['postUrl'],
        datePublished: snapshot['datePublished'],
        like: snapshot['like'],
        profImage: snapshot['profImage']);
  }
}
