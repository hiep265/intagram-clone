import 'package:flutter/material.dart';
import 'package:intagram/models/user.dart';
import 'package:intagram/resource/auth_methos.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get getuser => _user!;
  final AuthMethos _authMethos = AuthMethos();
  Future<void> refreshUser() async {
    User user = await _authMethos.getUserDetail();
    _user = user;
    notifyListeners();
  }
}
