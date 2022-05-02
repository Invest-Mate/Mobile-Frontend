import 'package:flutter/cupertino.dart';

import '2.auth_user.dart';

abstract class AuthProvider {
  // Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> signInWithGoogle();
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> otpLogin({required String phone, required BuildContext context});
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
