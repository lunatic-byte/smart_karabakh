import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'const_colors.dart';
import 'const_styles.dart';

Widget MyButton(
    {required Widget child,
    required BoxDecoration decoration,
    required VoidCallback onPressed,
    double paddingVertical = 30}) {
  return GestureDetector(
    onTap: () {
      onPressed.call();
    },
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: paddingVertical.h),
      decoration: decoration,
      child: Center(child: child),
    ),
  );
}

class MyTextField extends StatelessWidget {
  BoxDecoration decoration;
  TextEditingController? controller;
  TextStyle? hintStyle;
  TextStyle? textStyle;
  EdgeInsets? padding;
  FocusNode? focusNode;
  int maxLength;

  TextInputFormatter? inputFormatter;
  String? hint;
  VoidCallback? onTap;
  Function(String)? onChanged;
  TextInputType? type = TextInputType.text;
  int maxLines = 1;
  bool readOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextField(
        maxLines: maxLines,
        onChanged: onChanged,
        focusNode: focusNode,
        minLines: 1,
        keyboardAppearance: Brightness.dark,
        readOnly: readOnly,
        keyboardType: type,
        onTap: () {
          onTap?.call();
        },
        controller: controller,
        style: textStyle,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.zero,
          hintStyle: hintStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }

  MyTextField(
      {Key? key,
      required this.decoration,
      this.controller,
      this.hintStyle,
      this.textStyle,
      this.padding,
      this.hint,
      this.inputFormatter,
      this.onTap,
      this.onChanged,
      this.maxLength = 500,
      this.type,
      this.focusNode,
      this.maxLines = 1,
      this.readOnly = false})
      : super(key: key);
}

enum SnackState {
  ERROR,
  INFORMATION,
  SUCCESS,
}

void showSnackBar(
    {SnackState state = SnackState.INFORMATION,
    String title = "-",
    String message = ""}) {
  Get.snackbar(
    "",
    "",
    colorText: whiteColor,
    snackStyle: SnackStyle.FLOATING,
    titleText: Text(
      title == "-" ? titleOfSnack(state) : title,
      style: largeText(whiteColor, bold: true),
    ),
    messageText: Text(
      message,
      style: normalText(whiteColor),
    ),
    margin: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 10.w,
    ),
    padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.w),
    borderColor: backColor(state),
    borderRadius: 15.r,
    borderWidth: 0.1.w,
    backgroundColor: backColor(state).withOpacity(0.31),
  );
}

Color backColor(SnackState state) {
  return (state == SnackState.INFORMATION)
      ? infoColor
      : (state == SnackState.ERROR)
          ? errorColor
          : primaryColor;
}

String titleOfSnack(SnackState state) {
  return (state == SnackState.INFORMATION)
      ? "information"
      : (state == SnackState.ERROR)
          ? "error"
          : 'successfully';
}

Widget loadingWidget({double width = 70}) {
  return ColorFiltered(
    colorFilter: const ColorFilter.mode(
      primaryColor,
      BlendMode.srcATop,
    ),
    child: CupertinoActivityIndicator(
      radius: width.w,
    ),
  );
}

Widget OwnImage(String url,
    {double aspectRatio = 1, double width = 100, bool oval = false}) {
  double _width = width;
  double _height = width / aspectRatio;

  return ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(oval ? width : 10.w)),
    child: Container(
      decoration: decoration1(darkColor),
      height: _height,
      width: _width,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        height: _height,
        width: _width,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  downloadProgress.progress != null
                      ? ((downloadProgress.progress! * 100).toStringAsFixed(2) +
                          "%")
                      : "0%",
                  style: smallText(whiteColor),
                ),
                LinearProgressIndicator(
                  value: downloadProgress.progress,
                  color: primaryColor,
                  backgroundColor: passiveColor,
                ),
              ],
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Center(
            child: Icon(
              Icons.error_outline,
              color: errorColor,
              size: _height / 5,
            ),
          );
        },
      ),
    ),
  );
}

MyHero({required Widget child, required String tag}) {
  return Hero(
    flightShuttleBuilder: (_,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext) {
      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (_, _child) {
          return DefaultTextStyle.merge(
            child: _child!,
            style: TextStyle.lerp(
                DefaultTextStyle.of(fromHeroContext).style,
                DefaultTextStyle.of(toHeroContext).style,
                flightDirection == HeroFlightDirection.pop
                    ? 1 - animation.value
                    : animation.value),
          );
        },
      );
    },
    tag: tag,
    child: child,
  );
}
