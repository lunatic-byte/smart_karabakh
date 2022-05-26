import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<BuildContext?> get getContext async {
  if (Get.context == null) {
    for (int i = 0; i < 10; i++) {
      if (Get.context == null) {
        await Future.delayed(const Duration(milliseconds: 1000));
        print(i);
      } else {
        print('here');
        return Get.context;
      }
    }
  }
  return Get.context;
}

myLog(data) {
  if (kDebugMode) {
    log(data.toString());
  }
}

Future<dynamic> push(Widget page) async {
  return Navigator.push((await getContext)!, MaterialPageRoute(builder: (_) {
    return page;
  }));
}

pop() async {
  if (Navigator.canPop((await getContext)!)) {
    Navigator.pop((await getContext)!);
  } else {
    myLog('Can not dismiss');
  }
}

replace(Widget page) async {
  Navigator.pushReplacement((await getContext)!,
      MaterialPageRoute(builder: (_) {
    return page;
  }));
}

bool keyboardIsActive() {
  if (WidgetsBinding.instance == null) {
    return false;
  }
  return (WidgetsBinding.instance!.window.viewInsets.bottom > 0.0);
}

void dismissKeyboard() {
  try {
    FocusManager.instance.primaryFocus?.unfocus();
  } catch (e) {
    myLog(e);
  }
}

String reduceNum(num number) {
  return abs(number) > 999999
      ? ((number / 1000000).toStringAsFixed(1) + "M")
      : abs(number) > 999
          ? ((number / 1000).toStringAsFixed(1) + "K")
          : number.toStringAsFixed(1);
}

num abs(number) {
  if (number < 0) {
    return number * -1;
  } else {
    return number;
  }
}
