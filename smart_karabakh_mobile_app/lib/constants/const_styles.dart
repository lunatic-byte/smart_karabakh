import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'const_colors.dart';

TextStyle smallText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      decoration: TextDecoration.none,
      fontSize: 14.sp);
}

TextStyle normalText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      decoration: TextDecoration.none,
      color: color,
      fontSize: 16.sp);
}

TextStyle tinyText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      decoration: TextDecoration.none,
      fontSize: 12.sp);
}

TextStyle largeText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      decoration: TextDecoration.none,
      fontSize: 18.sp);
}

TextStyle bigText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      decoration: TextDecoration.none,
      fontSize: 30.sp);
}

TextStyle uLargeText(Color color, {bool bold = false}) {
  return TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      decoration: TextDecoration.none,
      fontSize: 65.sp);
}

BoxDecoration decoration1(Color color, {double radius = 10}) {
  return BoxDecoration(
      color: color, borderRadius: BorderRadius.all(Radius.circular(radius.r)));
}

BoxDecoration decoration3(Color color, {double radius = 10}) {
  return BoxDecoration(
      color: color,
      boxShadow: [
        BoxShadow(
            color: mainColor,
            blurStyle: BlurStyle.solid,
            blurRadius: (radius / 10).r),
        BoxShadow(
            color: darkColor,
            blurStyle: BlurStyle.solid,
            offset: Offset(1, 1),
            blurRadius: (radius / 10).r),
      ],
      borderRadius: BorderRadius.only(topLeft: Radius.circular(radius.r)));
}

BoxDecoration decoration4(Color color, {double radius = 10}) {
  return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(radius.r)));
}

BoxDecoration decorationBorder(Color color,
    {double radius = 10, double width = 1.9}) {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius.r)),
      border: Border.all(color: color, width: width.r));
}

BoxDecoration decoration2(
  Color color,
) {
  return BoxDecoration(color: color, shape: BoxShape.circle);
}
