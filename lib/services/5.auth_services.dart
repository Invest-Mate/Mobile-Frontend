import 'package:flutter/cupertino.dart';
import '2.auth_user.dart';
import '3.auth_provider.dart';
import '4.firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future otpLogin({required String phone, required BuildContext context}) =>
      provider.otpLogin(
        context: context,
        phone: phone,
      );
  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
