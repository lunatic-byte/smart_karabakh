import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:own_appbar/own_appbar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_karabakh/constants/const_methods.dart';

import '../constants/const_styles.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key}) : super(key: key);

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: OwnAppBar(
          sizeFactor: 18,
          leadingIcon: Icons.arrow_back_ios,
          backgroundColor: Colors.white,
          key: Key("appBar"),
          iconFactor: 1.8,
          context: context,
          actionClicked: (actionName) {
            print(actionName);
            pop();
          },
          centerChild: Text(
            "Qr Code",
            style: bigText(Colors.black, bold: true),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImage(
                data: FirebaseAuth.instance.currentUser!.uid,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "This QR code represents a unique id for each user. In order to use in parking places!",
                  style: largeText(
                    Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
