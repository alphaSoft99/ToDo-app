import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/main/navigation.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';

class AppBarNotification extends StatelessWidget {

  final MainNotifier mainNotifier;
  final TodoEntry todoEntry;

  AppBarNotification({this.mainNotifier, this.todoEntry});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 106,
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 12,
      ),
      decoration: BoxDecoration(
          color: whiteColor.withOpacity(0.31),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                localisedString(context, 'today_reminder'),
                style: whiteHeadingTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                todoEntry.content,
                style: subtitleHeadingTextStyle,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "${DateFormat("HH:mm").format(todoEntry.targetDate)}",
                style: subtitleHeadingTextStyle,
              ),
            ],
          ),
          Positioned(
            top: 24,
            right: 32,
            child: SvgPicture.asset(
              'assets/svg/bell.svg',
              width: 52,
              height: 66,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                mainNotifier.changeNotification(false);
              },
              icon: Icon(
                Icons.clear,
                color: whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
