import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';

class BottomNavBar extends StatelessWidget {

  final mainNotifier;

  BottomNavBar({this.mainNotifier});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: buttonHeightForPlatform(64),
      child: BottomNavigationBar(
        currentIndex: mainNotifier.index,
        onTap: mainNotifier.changeIndex,
        backgroundColor: whiteColor,
        elevation: 6,
        selectedLabelStyle: bottomBarTextStyle,
        unselectedLabelStyle: bottomBarTextStyle.copyWith(color: Color(0xFF9F9F9F)),
        items: [
          BottomNavigationBarItem(
              title: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  localisedString(context, 'home'),
                ),
              ),
              activeIcon: SvgPicture.asset(
                "assets/svg/home.svg",
                width: 24,
                height: 24,
                color: Color(0xFF5F87E7),
              ),
              icon: SvgPicture.asset(
                "assets/svg/home.svg",
                width: 24,
                height: 24,
                color:  Color(0xFFBEBEBE)
              )),
          BottomNavigationBarItem(
              title: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  localisedString(context, 'tasks'),
                ),
              ),
              activeIcon: SvgPicture.asset(
                "assets/svg/tasks.svg",
                width: 24,
                height: 24,
                color: Color(0xFF5F87E7),
              ),
              icon: SvgPicture.asset(
                "assets/svg/tasks.svg",
                width: 24,
                height: 24,
                color:  Color(0xFFBEBEBE)
              )),
        ],
      ),
    );
  }
}
