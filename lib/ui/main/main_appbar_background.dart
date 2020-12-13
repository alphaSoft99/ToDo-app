import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/ui/setting/change_language_page.dart';
import 'package:todo/utils/style_guide.dart';

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
              backgroundColor: whiteColor,
              child: SvgPicture.asset(
                "assets/svg/settings.svg",
                color: Color(0xFF32A6DE),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
