import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

Future<Response?> getResponse(String url) async {
  try {
    Response response = await Dio().get(url);
    print(response.data);
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Response?> postPayload(String url, Map body) async {
  try {
    Response response = await Dio().post(url, data: body);
    print(response.data);
    return response;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
