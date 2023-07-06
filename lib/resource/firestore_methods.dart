import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intagram/models/post.dart';
import 'package:intagram/resource/storage_methos.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String userName, String profImage) async {
    String res = 'some error occurred';
    String postId = const Uuid().v1();
    try {
      String photoUrl =
          await StorageMethos().uploadImageToStorage('posts', file, true);
      Post post = Post(
          username: userName,
          uid: uid,
          description: description,
          postId: postId,
          postUrl: photoUrl,
          datePublished: DateTime.now(),
          like: [],
          profImage: profImage);
      await _firestore.collection('posts').doc(postId).set(post.toJsong());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List Like) async {
    try {
      if (Like.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> postComment(
    String postId,
    String comment,
    String username,
    String imageurl,
    String uid,
  ) async {
    String commentId = const Uuid().v1();
    try {
      if (comment.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comment')
            .doc(commentId)
            .set({
          'comment': comment,
          'username': username,
          'imageurl': imageurl,
          'uid': uid,
          'commentid': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> deletePost(String postId) async {
    String res = 'some error';

    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'Delete success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> follow(String currentUid, String followUid) async {
    try {
      await _firestore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayUnion([currentUid])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> unFollow(String currentUid, String followUid) async {
    try {
      await _firestore.collection('users').doc(followUid).update({
        'followers': FieldValue.arrayRemove([currentUid])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> Following(String currentUid, String followUid) async {
    try {
      await _firestore.collection('users').doc(currentUid).update({
        'followings': FieldValue.arrayUnion([followUid])
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> UnFollowing(String currentUid, String followUid) async {
    try {
      await _firestore.collection('users').doc(currentUid).update({
        'followings': FieldValue.arrayRemove([followUid])
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
