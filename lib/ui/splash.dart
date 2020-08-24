import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: "logo",
              child: SvgPicture.asset(
                'assets/svg/logo.svg',
                semanticsLabel: 'Tasks',
                width: 180,
                height: 200,
              ),
            ),
          )
        ],
      ),
    );
  }
}
