import 'package:shared_preferences/shared_preferences.dart';

import 'const_methods.dart';
import 'const_variables.dart';

class Initialize {
  Future<void> init() async {
    myLog("auth.currentUser.uid");
    myLog(auth.currentUser!.uid);
    await SharedPreferences.getInstance();
  }
}
