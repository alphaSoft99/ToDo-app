import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/common/todo_card.dart';
import 'package:todo/ui/main/navigation.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/styleguide.dart';

class HomePage extends StatefulWidget {

  final TodoAppBloc bloc;
  final MainNotifier mainNotifier;

  HomePage({this.bloc, this.mainNotifier});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final today = DateTime.now();
  DateTime _dateTime = DateTime.now();

  bool hasTitle(DateTime dateTime){
    if(dateTime.day > _dateTime.day && dateTime.month >= _dateTime.month && dateTime.year >= _dateTime.year || dateTime.month > _dateTime.month && dateTime.year >= _dateTime.year || dateTime.year > _dateTime.year){
      _dateTime = dateTime;
      return true;
    }
    return false;
  }

  String getTitle(DateTime dateTime, BuildContext context){
    if(dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year)
      return localisedString(context, 'today');
    if(dateTime.day == today.day + 1 && dateTime.month == today.month && dateTime.year == today.year)
      return localisedString(context, 'tomorrow');
    else
      return '${dateTime.day} ${localisedString(context, 'month_${dateTime.month}')}';
  }

  bool isToday(DateTime dateTime){
    return dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TodoEntry>>(
      stream: widget.bloc.homeScreenEntries,
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return emptyPage();
        }
        else if(snapshot.data.isEmpty){
          return emptyPage();
        }
        else {
          _dateTime = DateTime.now();
          return Padding(
            padding: EdgeInsets.only(bottom: widget.mainNotifier.isOpen? 64: 0),
            child: ListView.separated(
              separatorBuilder: (context, index){
                if(hasTitle(snapshot.data[index+1].targetDate)) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 16),
                    child: Text(getTitle(snapshot.data[index+1].targetDate, context),
                      style: fadedTextStyle.copyWith(fontSize: 14),),
                  );
                }
                return Container();
              },
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if(index == 0)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 16),
                        child: Text(getTitle(snapshot.data[0].targetDate, context), style: fadedTextStyle.copyWith(fontSize: 14),),
                      ),
                      TodoCard(snapshot.data[index]),
                    ],
                  );
                return TodoCard(snapshot.data[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget emptyPage(){
    return Padding(
      padding: EdgeInsets.only(bottom: widget.mainNotifier.isOpen? 64: 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/empty_task.svg',
            semanticsLabel: 'Empty Tasks',
            width: 120,
            height: 164,
          ),
          SizedBox(
            height: 64,
          ),
          Text(
            localisedString(context, 'no_tasks'),
            textAlign: TextAlign.center,
            style: fadedTextStyle,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            localisedString(context, 'no_task_to_do'),
            textAlign: TextAlign.center,
            style: subFadedTextStyle.copyWith(color: Color(0xFF82A0B7)),
          ),
        ],
      ),
    );
  }
}
