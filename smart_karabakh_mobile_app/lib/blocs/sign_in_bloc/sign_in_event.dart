part of 'sign_in_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignMeInEvent extends SignInEvent {
  final String number;
  final String smsCode;
  final bool checkBox;

  SignMeInEvent(this.number, this.smsCode, this.checkBox);
}

class SignInSmsSentEvent extends SignInEvent {}

class SignInResetEvent extends SignInEvent {
  bool allReset;

  SignInResetEvent(this.allReset);
}

class SignInDoneEvent extends SignInEvent {
  final PhoneAuthCredential credential;
  final bool withoutVID;

  SignInDoneEvent(this.credential, {this.withoutVID = true});
}

class SignInErrorEvent extends SignInEvent {
  final String errorMessage;
  final SignInErrors errorType;

  SignInErrorEvent(
      {required this.errorMessage,
      this.errorType = SignInErrors.firebaseError});
}
