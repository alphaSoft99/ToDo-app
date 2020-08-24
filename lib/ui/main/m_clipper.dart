
import 'package:flutter/material.dart';

class MClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    final radius = size.width / 13.0;
    path.moveTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, radius);

//    var leftPoint = Offset(1,  radius - 2);
//    var rightPoint = Offset(size.width - 1, radius - 2);
    var endPoint = Offset(size.width, radius);
    var centerPoint = Offset(size.width / 2, -radius);

    /*path.quadraticBezierTo(
        0, radius, leftPoint.dx, leftPoint.dy);
    path.quadraticBezierTo(
        leftPoint.dx, leftPoint.dy, centerPoint.dx, centerPoint.dy);
    path.quadraticBezierTo(
        centerPoint.dx, centerPoint.dy, rightPoint.dx, rightPoint.dy);*/
    path.quadraticBezierTo(
        centerPoint.dx, centerPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
