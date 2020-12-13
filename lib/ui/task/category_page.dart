import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/common/todo_by_category.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';

class CategoryPage extends StatefulWidget {
  final List<Category> categories;
  final Category category;
  final TodoAppBloc bloc;

  CategoryPage({this.category, this.categories, this.bloc});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
    if(dateTime.day == today.day - 1 && dateTime.month == today.month && dateTime.year == today.year)
      return localisedString(context, 'yesterday');
    if(dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year)
      return localisedString(context, 'today');
    else if(dateTime.day == today.day + 1 && dateTime.month == today.month && dateTime.year == today.year)
      return localisedString(context, 'tomorrow');
    else
      return '${dateTime.day} ${localisedString(context, 'month_${dateTime.month}')}';
  }

  bool isToday(DateTime dateTime){
    return dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year;
  }

  @override
  void initState() {
    super.initState();
    widget.bloc.showCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/svg/backward.svg',
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1,
        centerTitle: true,
        backgroundColor: getCategoryColor(widget.category.id),
        title: Text(localisedString(context, widget.category.description), style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 17)),
      ),
      body: StreamBuilder<List<EntryWithCategory>>(
        stream: widget.bloc.taskScreenEntries,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return emptyPage();
          }
          else if(snapshot.data.isEmpty){
            return emptyPage();
          }
          else {
            _dateTime = DateTime.now();
            return ListView.separated(
                separatorBuilder: (context, index){
                  if(hasTitle(snapshot.data[index+1].entry.targetDate)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: Text(getTitle(snapshot.data[index+1].entry.targetDate, context),
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
                          child: Text(getTitle(snapshot.data[0].entry.targetDate, context), style: fadedTextStyle.copyWith(fontSize: 14),),
                        ),
                        TodoByCategoryCard(entry: snapshot.data[index].entry, categories: widget.categories),
                      ],
                    );
                  return TodoByCategoryCard(entry: snapshot.data[index].entry, categories: widget.categories);
                },
            );
          }
        },
      ),
    );
  }

  Widget emptyPage(){
    return Column(
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
    );
  }
}
