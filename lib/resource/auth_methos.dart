import 'dart:typed_data';
import '../models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:intagram/resource/storage_methos.dart';

class AuthMethos {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<model.User> getUserDetail() async {
    User currenUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currenUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signupUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List? file}) async {
    String res = 'some error occrurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl = await StorageMethos()
            .uploadImageToStorage('profilePicture', file, false);
        model.User user = model.User(
            username: username,
            uid: _auth.currentUser!.uid,
            email: email,
            imageUrl: photoUrl,
            bio: bio,
            followers: [],
            following: []);
        _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJsong());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted';
      } else {
        if (err.code == 'weak-password') {
          res = 'Password should be at least 6 characters';
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'some error occrurred';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';

      return res;
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'Thrown if the email address is not valid';
      } else {
        if (err.code == 'user-not-found') {
          res = 'Thrown if there is no user corresponding to the given email';
        } else {
          if (err.code == 'wrong-password') {
            res = 'try again enter password';
          }
        }
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
