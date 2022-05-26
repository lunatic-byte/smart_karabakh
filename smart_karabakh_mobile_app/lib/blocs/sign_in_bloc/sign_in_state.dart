part of 'sign_in_bloc.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {
  bool allReset;

  SignInInitial(this.allReset);
}

class SignInProcessingState extends SignInState {}

class SignInCodeSentState extends SignInState {}

class SignInErrorState extends SignInState {
  final String errorMessage;
  final SignInErrors errorType;

  SignInErrorState({required this.errorMessage, required this.errorType});
}

class SignInDoneState extends SignInState {
  final PhoneAuthCredential credential;

  SignInDoneState(this.credential);
}
