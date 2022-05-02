// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

/**
 * * We have divide our app in different levels
 * ? We have done this so ui donot directly access our backend
 * * Differnt levels are :-
 * * 1.Auth Exception
 * * 2.Auth User
 * * 3.Auth Provider
 * * 4.Firebase Auth Provider
 * * 5.Auth Services
 * * 6.Main ui
 * ? We have implemented concept of Exception here
 */
