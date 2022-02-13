import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/common/item_category.dart';
import 'package:todo/utils/custom_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/utils/custom_datetime_picker/src/i18n_model.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';
import 'm_clipper.dart';

class AddTaskSheet extends StatefulWidget {
  final TodoAppBloc bloc;
  final int categoryId;
  final List<Category> categories;

  AddTaskSheet({this.bloc, this.categoryId, this.categories});

  @override
  _AddTaskSheetState createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController _controller = TextEditingController();
  final dateTime = DateTime.now();
  int categoryId = 0;
  DateTime _dateTime = DateTime.now();
  bool showErrorContext = false;

  changePos(int pos) {
    setState(() {
      categoryId = pos;
    });
  }

  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
  }

  bool isToday() {
    return dateTime.day == _dateTime.day && dateTime.month == _dateTime.month && dateTime.year == _dateTime.year;
  }

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).toString();
    LocaleType localeType;
    switch (locale) {
      case 'en':
        localeType = LocaleType.en;
        break;
      case 'ru':
        localeType = LocaleType.ru;
        break;
      case 'uz':
        localeType = LocaleType.uz;
        break;
    }

    return Container(
      height: 360,
      child: ClipPath(
        clipper: MClipper(),
        child: KeyboardAvoider(
          autoScroll: true,
          child: Container(
            color: whiteColor,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  localisedString(context, 'add_new_task'),
                  textAlign: TextAlign.center,
                  style: categoryTextStyle.copyWith(color: Color(0xFF404040)),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Color(0xFF373737),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    errorText: showErrorContext ? localisedString(context, 'write_your_task') : null,
                  ),
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  cursorWidth: 2,
                  cursorRadius: Radius.circular(1),
                  cursorColor: Color(0xFF373737),
                  controller: _controller,
                  showCursor: true,
                  enabled: true,
                  autofocus: true,
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFCFCFCF),
                ),
                Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                      itemCount: widget.categories.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ItemCategory(
                          category: widget.categories[index],
                          changePos: changePos,
                          pos: categoryId,
                        );
                      }),
                ),
                Divider(
                  height: 1,
                  color: Color(0xFFCFCFCF),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  localisedString(context, 'choose_date'),
                  style: titleTextStyle.copyWith(fontWeight: FontWeight.w400, color: Color(0xFF404040)),
                ),
                SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
                      onChanged: (date) {
                        print('changeDate: $date');
                      },
                      onConfirm: (date) {
                        setState(() {
                          _dateTime = date;
                        });
                      },
                      currentTime: DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute),
                      locale: localeType,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        isToday()
                            ? "${localisedString(context, 'today')}, ${_dateTime.hour.toString().padLeft(2, '0')} : ${_dateTime.minute.toString().padLeft(2, '0')}"
                            : "${localisedString(context, "month_${_dateTime.month}")} ${_dateTime.day}, ${_dateTime.hour.toString().padLeft(2, '0')} : ${_dateTime.minute.toString().padLeft(2, '0')}",
                        style: titleTextStyle.copyWith(fontWeight: FontWeight.w600, color: Color(0xFF404040)),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: SvgPicture.asset(
                          'assets/svg/following.svg',
                          height: 12,
                          width: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(colors: [
                      Color(0xFF7EB6FF),
                      Color(0xFF5F87E7),
                    ]),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (_controller.text.isEmpty) {
                        setState(() {
                          showErrorContext = true;
                        });
                        return;
                      } else if (showErrorContext) {
                        setState(() {
                          showErrorContext = false;
                        });
                      }
                      widget.bloc.createEntry(
                          TodoEntry(
                              id: 0,
                              content: _controller.text,
                              notification: true,
                              done: false,
                              targetDate:
                                  DateTime(_dateTime.year, _dateTime.month, _dateTime.day, _dateTime.hour, _dateTime.minute, 0, 0, 0),
                              category: categoryId),
                          context,
                          widget.categories[categoryId].description);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        localisedString(context, 'add_task'),
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
