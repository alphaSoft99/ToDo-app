import 'package:flutter/material.dart';
import 'package:todo/ui/profile/change_language_page.dart';
import 'package:todo/utils/styleguide.dart';

class MainAppBarBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          left: -80,
          top: -120,
          child: Container(
            height: 212,
            width: 212,
            decoration:
                BoxDecoration(color: whiteColor.withOpacity(0.17), shape: BoxShape.circle),
          ),
        ),
        Positioned(
          right: -10,
          top: -32,
          child: Container(
            height: 96,
            width: 96,
            decoration:
                BoxDecoration(color: whiteColor.withOpacity(0.17), shape: BoxShape.circle),
          ),
        ),
        Positioned(
          top: 46,
          right: 16,
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeLanguagePage()));
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Image.asset(
                  "assets/images/flutter.png",
                  height: 28,
                  width: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
