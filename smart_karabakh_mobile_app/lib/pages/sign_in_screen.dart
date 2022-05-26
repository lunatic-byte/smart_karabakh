import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../constants/const_colors.dart';
import '../constants/const_methods.dart';
import '../constants/const_styles.dart';
import '../constants/const_widgets.dart';
import '../constants/my_expansion.dart';
import '../custom_paints/bottom_paint.dart';
import '../custom_paints/head_paint.dart';
import 'main_router.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key? key}) : super(key: key);
  TextEditingController numController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: BlocConsumer<SignInBloc, SignInState>(
          listener: (_, state) async {
            if (state is SignInInitial) {
              if (state.allReset) {
                codeController.clear();
                numController.clear();
              } else {
                codeController.clear();
              }
            } else if (state is SignInErrorState) {
              showSnackBar(
                  title: "Error",
                  state: SnackState.ERROR,
                  message: ((state.errorMessage != "wrong-sms-code" ||
                          state.errorMessage != "invalid-phone-number")
                      ? "Try Again (${state.errorMessage})"
                      : state.errorMessage));
            } else if (state is SignInDoneState) {
              myLog("state.credential");
              myLog(state.credential);
              try {
                replace(MainRouter());
              } catch (e) {
                context
                    .read<SignInBloc>()
                    .add(SignInErrorEvent(errorMessage: 'internet_error'));
              }
            }
          },
          builder: (context, state) {
            if (state is SignInProcessingState) {
              return Center(child: loadingWidget());
            }
            return Stack(
              children: [
                !keyboardIsActive()
                    ? Positioned(
                        bottom: 0,
                        right: 0,
                        child: CustomPaint(
                          size: MediaQuery.of(context).size,
                          painter: BottomPaint(),
                        ),
                      )
                    : const SizedBox.shrink(),
                Positioned(
                  top: 0,
                  left: 0,
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    //You can Replace this with your desired WIDTH and HEIGHT
                    painter: HeaderPaint(),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Login",
                          style: bigText(Colors.black, bold: true),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        MyExpansionTile(
                          expand: state is SignInCodeSentState,
                          child: MyTextField(
                            hint: "Enter Phone Number",
                            decoration: decoration1(blueColor.withOpacity(0.1)),
                            type: TextInputType.number,
                            textStyle: normalText(
                                Colors.black87.withOpacity(0.69),
                                bold: true),
                            hintStyle:
                                smallText(Colors.black87.withOpacity(0.5)),
                            readOnly: state is SignInCodeSentState,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            controller: numController,
                            onTap: () {
                              if (numController.text.isEmpty) {
                                numController.text = "+1";
                              }
                            },
                          ),
                          children: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                            ),
                            child: MyTextField(
                              hint: "Enter SMS code",
                              maxLength: 6,
                              type: TextInputType.number,
                              decoration:
                                  decoration1(blueColor.withOpacity(0.1)),
                              textStyle: normalText(
                                  Colors.black87.withOpacity(0.69),
                                  bold: true),
                              hintStyle:
                                  smallText(Colors.black87.withOpacity(0.5)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              controller: codeController,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MyButton(
                          decoration: decoration1(Colors.blue.withOpacity(0.7)),
                          paddingVertical: 20,
                          child: Text(
                            'Submit',
                            style: normalText(whiteColor, bold: true),
                          ),
                          onPressed: () {
                            context.read<SignInBloc>().add(
                                  SignMeInEvent(
                                    numController.text.trim(),
                                    codeController.text.trim(),
                                    accepted,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 120,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
