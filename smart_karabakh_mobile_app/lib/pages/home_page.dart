import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_karabakh/constants/const_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Response>(
        future: Dio().get(
            'http://us-central1-smartkarabakh.cloudfunctions.net/main/main/getWeaterData'),
        builder:
            (BuildContext context, AsyncSnapshot<Response<dynamic>> snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          print(snapshot.data!.data as List);
          // return ListView.builder(
          //   itemCount: (snapshot.data!.data as List).length,
          //   itemBuilder: (ctx, index) {
          //     return Container(
          //       child:
          //           Text((snapshot.data!.data as List)[index].toString()),
          //     );
          //   },
          // );

          return Center(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  SizedBox(
                    width: 200,
                    child: Image.asset('assets/wh.png'),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: decoration1(Colors.amber),
                        child: Text(
                          (snapshot.data!.data as List).last['t'] + "°C",
                          style: largeText(Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: decoration1(Colors.blue),
                        child: Text(
                          (snapshot.data!.data as List).last['h'] + "%",
                          style: largeText(Colors.black),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Text(
                      !conditionReturner(
                              (snapshot.data!.data as List).last['h'],
                              (snapshot.data!.data as List).last['t'])
                          ? "Weather conditions is ideal for driving, and there are no frozen road barriers."
                          : "Weather conditions is not ideal for driving, and there are frozen roads.",
                      style: largeText(
                        !conditionReturner(
                                (snapshot.data!.data as List).last['h'],
                                (snapshot.data!.data as List).last['t'])
                            ? Colors.green
                            : Colors.red,
                        bold: true,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      child: !conditionReturner(
                              (snapshot.data!.data as List).last['h'],
                              (snapshot.data!.data as List).last['t'])
                          ? Icon(
                              Icons.done,
                              color: Colors.green,
                              size: 100,
                            )
                          : Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 100,
                            )),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool conditionReturner(var h, var t) {
    if (double.parse(h) < 40 && double.parse(t) < 0) {
      return true;
    }
    return false;
  }
}
