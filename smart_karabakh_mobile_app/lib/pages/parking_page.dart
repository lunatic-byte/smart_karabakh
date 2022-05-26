import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:smart_karabakh/constants/const_styles.dart';
import 'package:smart_karabakh/constants/const_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/const_variables.dart';
import '../main.dart';
import '../repos/helpers.dart';

class ParkingPage extends StatefulWidget {
  const ParkingPage({Key? key}) : super(key: key);

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  String userID = auth.currentUser!.uid;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.7518853, 46.7464237),
    zoom: 14.4746,
  );
  late GoogleMapController controller;
  Set<Marker> markers = {};
  Uint8List? markerIcon;

  @override
  void initState() {
    setIcon();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return reserved
        ? ReservationPanel()
        : Container(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Parking').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  markers.clear();
                  snapshot.data!.docs.forEach((element) {
                    print("lattt");

                    if (listReturner((element.data() as Map)["users"] ?? [])
                        .contains(userID)) {
                      refresh(
                          (element.data() as Map)["id"],
                          (element.data() as Map)["lat"],
                          (element.data() as Map)["lon"]);
                    }

                    print((element.data() as Map)["lat"]);
                    if (markerIcon != null) {
                      markers.add(Marker(
                        icon: BitmapDescriptor.fromBytes(markerIcon!),
                        markerId: MarkerId(
                            "${(element.data() as Map)["lat"]}${(element.data() as Map)["lon"]}"),
                        position: LatLng(
                          (element.data() as Map)["lat"],
                          (element.data() as Map)['lon'],
                        ),
                        infoWindow: InfoWindow(
                          title: "Empty: ${(element.data() as Map)["count"]}",
                          snippet: (element.data() as Map)["name"],
                        ),
                        onTap: () {
                          tappedMArker(
                            (element.data() as Map)["id"],
                            (element.data() as Map)["count"],
                            listReturner((element.data() as Map)["users"] ?? [])
                                .contains(userID),
                            (element.data() as Map)["lat"],
                            (element.data() as Map)["lon"],
                          );
                          print("tapped");
                          //
                        },
                      ));
                    } else {
                      markers.add(Marker(
                        markerId: MarkerId(
                            "${(element.data() as Map)["lat"]}${(element.data() as Map)["lon"]}"),
                        position: LatLng(
                          (element.data() as Map)["lat"],
                          (element.data() as Map)['lon'],
                        ),
                        infoWindow: InfoWindow(
                            title: "Empty: ${(element.data() as Map)["count"]}",
                            snippet: 'Have a nice day'),
                        onTap: () {
                          //
                        },
                      ));
                    }
                  });
                }
                return GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    this.controller = controller;
                  },
                );
              },
            ),
          );
  }

  Future<void> setIcon() async {
    markerIcon = await getBytesFromAsset('assets/parking.png', 100);
  }

  void tappedMArker(
      String docID, int count, bool reservedBefore, double lan, double lon) {
    if (reservedBefore) {
      Get.bottomSheet(
        Container(
            // height: 150,
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "If reservation cancels before 15 minutes the 20% of amount will be returned!",
                  style: largeText(Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: MyButton(
                    paddingVertical: 19,
                    child: Text(
                      "Cancel Reservation",
                      style: normalText(Colors.black),
                    ),
                    decoration: decoration1(
                      Colors.green,
                    ),
                    onPressed: () {
                      reserveBackPlace(docID);
                    },
                  ),
                ),
              ],
            )),
        isDismissible: true,
      );
      return;
    }
    Get.bottomSheet(
      Container(
          // height: 150,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "We found ${count} free places. Reserve yours!",
                style: largeText(Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: MyButton(
                  paddingVertical: 19,
                  child: Text(
                    "I'll be in 15 min.",
                    style: normalText(Colors.black),
                  ),
                  decoration: decoration1(
                    Colors.green,
                  ),
                  onPressed: () {
                    reserved = true;
                    this.lan = lan;
                    this.lon = lon;
                    reservePlace(docID);
                    setState(() {});
                  },
                ),
              )
            ],
          )),
      isDismissible: true,
    );
  }

  bool reserved = false;
  double lan = 0;
  double lon = 0;

  void reservePlace(
    String docID,
  ) async {
    Get.back();

    this.docID = docID;
    await FirebaseFirestore.instance.collection("Parking").doc(docID).set(
      {
        "count": FieldValue.increment(-1),
        "users": [userID],
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  listReturner(data) {
    List returner = [];
    data.forEach((element) {
      returner.add(element.toString());
    });

    return returner;
  }

  void reserveBackPlace(String docID) async {
    Get.back();
    await FirebaseFirestore.instance.collection("Parking").doc(docID).set(
      {
        "count": FieldValue.increment(1),
        "users": [],
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  String docID = "";

  Widget ReservationPanel() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Please don't be late, otherwise the parking reservation fee will be applied and reservation will be cancelled!",
            style: largeText(
              Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          QrImage(
            data: userID,
            version: QrVersions.auto,
            size: 320,
            gapless: false,
          ),
          SizedBox(
            height: 15,
          ),
          SlideCountdownSeparated(
            height: 55,
            width: 55,
            onDone: () {
              prefs!.remove("counter");
            },
            textStyle: largeText(
              Colors.white,
              bold: true,
            ),
            duration: Duration(
              seconds: 900,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(7),
            child: MyButton(
              paddingVertical: 19,
              child: Text(
                "Find Direction",
                style: normalText(Colors.white, bold: true),
              ),
              decoration: decoration1(
                Colors.green,
              ),
              onPressed: () async {
                String googleUrl = 'google.navigation:q=$lan,$lon';

                await launchUrl(Uri.parse(googleUrl));
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7),
            child: MyButton(
              paddingVertical: 19,
              child: Text(
                "Cancel Reservation",
                style: normalText(Colors.white, bold: true),
              ),
              decoration: decoration1(
                Colors.red,
              ),
              onPressed: () {
                reserved = false;

                reserveBackPlace(docID);
                this.docID = "";
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  void refresh(id, double lan, double lon) {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      docID = id;
      //
      reserved = true;
      this.lan = lan;
      this.lon = lon;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
