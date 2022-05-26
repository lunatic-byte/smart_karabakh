import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_karabakh/blocs/sign_in_bloc/sign_in_enums.dart';

import '../../constants/const_methods.dart';
import '../../constants/const_variables.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc() : super(SignInInitial(true)) {
    on<SignMeInEvent>(_load);
    on<SignInResetEvent>(_resetState);
    on<SignInSmsSentEvent>(_smsSent);
    on<SignInErrorEvent>(_errorHappened);
    on<SignInDoneEvent>(_allDone);
  }

  static int? resendToken;
  String? verificationId;

  Future<void> _load(SignMeInEvent event, Emitter<SignInState> emit) async {
    dismissKeyboard(); //hie keyboard

    if (event.number.isEmpty) {
      emit(SignInErrorState(
          errorType: SignInErrors.emptyNumber, errorMessage: 'empty-number'));
    } else if (event.smsCode.isEmpty) {
      emit(SignInProcessingState());

      myLog(event.number);
      auth.verifyPhoneNumber(
        phoneNumber: event.number,
        timeout: const Duration(seconds: 90),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          myLog(credential);
          try {
            await auth.signInWithCredential(credential);
            add(SignInDoneEvent(credential, withoutVID: false));
          } catch (err) {
            add(SignInErrorEvent(
                errorType: SignInErrors.firebaseError,
                errorMessage: 'wrong-sms-code'));
            myLog(err);
            reset(false);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          myLog(e);
          add(
            SignInErrorEvent(
                errorMessage: e.code, errorType: SignInErrors.firebaseError),
          );
          reset(true);
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;

          resendToken = resendToken;

          add(
            SignInSmsSentEvent(),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (disposed) {
            return;
          }
          add(
            SignInErrorEvent(
                errorType: SignInErrors.firebaseError,
                errorMessage: 'sms-timeout'),
          );
          reset(false);
        },
      );
    } else {
      emit(SignInProcessingState());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId ?? "", smsCode: event.smsCode);

      try {
        await auth.signInWithCredential(credential);
        add(SignInDoneEvent(credential, withoutVID: false));
      } catch (err) {
        add(SignInErrorEvent(
            errorType: SignInErrors.firebaseError,
            errorMessage: 'wrong-sms-code'));
        myLog(err);
        reset(false);
      }
    }
  }

  reset(bool allReset) {
    add(SignInResetEvent(allReset));
  }

  FutureOr<void> _resetState(
      SignInResetEvent event, Emitter<SignInState> emit) {
    emit(SignInInitial(event.allReset));
  }

  FutureOr<void> _smsSent(SignInSmsSentEvent event, Emitter<SignInState> emit) {
    emit(SignInCodeSentState());
  }

  bool disposed = false;

  FutureOr<void> _errorHappened(
      SignInErrorEvent event, Emitter<SignInState> emit) {
    if (disposed) {
      return null;
    }
    emit(SignInErrorState(
        errorMessage: event.errorMessage, errorType: event.errorType));
  }

  Future<FutureOr<void>> _allDone(
      SignInDoneEvent event, Emitter<SignInState> emit) async {
    try {
      emit(SignInDoneState(event.credential));
      disposed = true;
    } catch (e) {
      add(SignInErrorEvent(errorMessage: "internet_error"));
    }
  }
}
