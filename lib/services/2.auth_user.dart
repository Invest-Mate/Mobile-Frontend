import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
  //Idhar user le raha hain factory aur agar user verified hoga tabhi
  //aage badhenge
  //Middleware ki atrah samajhlete hain
}
