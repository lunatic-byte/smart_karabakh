import '../constants/const_variables.dart';

class AuthRepo {
  //Factory Properties
  static final AuthRepo _authRepo = AuthRepo._();

  AuthRepo._();

  factory AuthRepo() {
    return _authRepo;
  }

//Factory Properties

  get isLoggedIn {
    return auth.currentUser != null;
  }

  get user {
    return auth.currentUser;
  }

  int? myForceResendingToken;
}
