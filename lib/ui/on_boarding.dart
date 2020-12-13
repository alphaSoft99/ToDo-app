import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/storage_util.dart';
import 'package:todo/utils/style_guide.dart';

import 'main/mian_page.dart';

class OnBoarding extends StatelessWidget {

  saveState() async {
    await StorageUtil.getInstance().then((value) async {
       await StorageUtil.saveOpenPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    saveState();
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Hero(
                tag: "logo",
                child: SvgPicture.asset(
                  'assets/svg/logo.svg',
                  semanticsLabel: 'Tasks',
                  width: 180,
                  height: 200,
                ),
              ),
              SizedBox(
                height: 120,
              ),
              Text(
                localisedString(context, 'reminders_made_simple'),
                style: fadedTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  localisedString(context, 'description'),
                  style: subFadedTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 56,
                margin: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      colors: [
                    Color(0xFF5DE61A),
                    Color(0xFF39A801),
                  ]),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  child: Center(
                    child: Text(
                      localisedString(context, 'get_started'),
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
