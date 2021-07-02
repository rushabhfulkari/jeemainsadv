import 'package:flutter/material.dart';
import 'package:jeemainsadv/constants/colors.dart';

Widget brandName(String text, BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: size.height / 45,
          fontWeight: FontWeight.bold,
          color: black,
        ),
      ),
    ],
  );
}

Widget pdfviewname(String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        fit: FlexFit.loose,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w200,
            color: black,
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
