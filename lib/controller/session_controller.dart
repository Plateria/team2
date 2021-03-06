import 'dart:async';

import 'package:courses_in_english/model/user/user.dart';

abstract class SessionController {
  bool get isLoggedIn;

  User get user;

  Future<User> login(String email, String password);

  Future<bool> requestPasswordReset(String userMail);

  Future<bool> resetPassword(
      String userMail, String resetCode, String newPassword);
}
