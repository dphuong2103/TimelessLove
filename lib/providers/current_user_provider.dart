import 'package:flutter/material.dart';

import '../models/user.dart';

class CurrentUserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  set currentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }

  set userWithoutNotify(UserModel? user) {
    _currentUser = user;
  }
}
