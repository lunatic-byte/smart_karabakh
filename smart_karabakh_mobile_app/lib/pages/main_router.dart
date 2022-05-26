import 'package:flutter/material.dart';
import 'package:own_appbar/own_appbar.dart';
import 'package:own_navbar/own_navbar.dart';
import 'package:smart_karabakh/constants/const_methods.dart';
import 'package:smart_karabakh/pages/parking_page.dart';
import 'package:smart_karabakh/pages/qr_code_Screen.dart';

import 'home_page.dart';
import 'info_page.dart';

class MainRouter extends StatefulWidget {
  const MainRouter({Key? key}) : super(key: key);

  @override
  State<MainRouter> createState() => _MainRouterState();
}

class _MainRouterState extends State<MainRouter> {
  List<Widget> routes = [
    ParkingPage(),
    HomePage(),
    InfoPage(),
  ];
  List<NavBarItem> items = [
    NavBarItem(
      elementIcon: Icons.car_repair,
      elementName: "Parking",
      navigationId: 'parking',
    ),
    NavBarItem(
      elementIcon: Icons.sunny,
      elementName: "Weather",
      navigationId: '__',
    ),
    NavBarItem(
      elementIcon: Icons.info,
      elementName: "About",
      navigationId: 'about',
    ),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: OwnAppBar(
          sizeFactor: 18,
          backgroundColor: Colors.white,
          key: Key("appBar"),
          iconFactor: 1.8,
          context: context,
          leadingColor: Colors.black,
          tailingColor: Colors.black,
          tailingIcon: Icons.qr_code,
          actionClicked: (actionName) {
            print(actionName);
            push(QrCodeScreen());
          },
          logoID: "assets/logo.png",
        ),
        bottomNavigationBar: BottomNavbar(
          backgroundColor: Colors.white,
          navItems: items,
          activeColor: Colors.black,
          passiveColor: Colors.grey,
          height: MediaQuery.of(context).size.height / 18,
          itemClicked: (int index, String navId) {
            print('Clicked index is $index \nClicked NavId is $navId');
            setState(() {
              currentPage = index;
            });
          },
        ),
        body: routes[currentPage],
      ),
    );
  }
}
