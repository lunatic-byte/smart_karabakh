import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_karabakh/pages/sign_in_screen.dart';

import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import '../constants/const_methods.dart';
import '../constants/const_widgets.dart';
import '../constants/init.dart';
import '../repos/auth_repo.dart';
import 'main_router.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key}) : super(key: key) {
    userInit();
  }

  @override
  Widget build(BuildContext context) {
    initUtil(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: loadingWidget(),
      ),
    );
  }

  void initUtil(BuildContext context) {
    ScreenUtil.init(context);
  }

  void userInit() async {
    print("Initializing process started!");
    print(AuthRepo().isLoggedIn);
    if (AuthRepo().isLoggedIn) {
      try {
        await Initialize().init();
        replace(MainRouter());
      } catch (e) {
        myLog(e);
        showSnackBar(
            state: SnackState.INFORMATION, message: ("Internet Error"));
        Future.delayed(const Duration(milliseconds: 5000)).then((value) {
          userInit();
        });
      }
    } else {
      replace(BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(),
        child: SignInScreen(),
      ));
    }
  }
}
