import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/blocs/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/custom_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/utils/custom_datetime_picker/src/i18n_model.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';
import 'item_edit_category.dart';
/// Card that displays an entry and an icon buttons to delete or edit that entry
class TodoCard extends StatelessWidget {
  final TodoEntry entry;
  final List<Category> categories;
  final TextEditingController textController = TextEditingController();
  TodoCard({this.entry, this.categories}) : super(key: ObjectKey(entry.id));

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.16,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: whiteColor),
          child: Stack(
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                title: Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    entry.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: entry.done ? doneTextStyle: titleTextStyle,
                  ),
                ),
                leading: CircularCheckBox(
                  inactiveColor: Color(0xFFB5B5B5),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  activeColor: getCategoryColor(entry.category),
                  onChanged: (value) {
                    BlocProvider.provideBloc(context).updateEntry(entry.copyWith(done: value));
                  },
                  value: entry.done,
                ),
                trailing: IconButton(
                  onPressed: () {
                    BlocProvider.provideBloc(context).updateEntry(entry.copyWith(notification: !entry.notification));
                  },
                  icon: Icon(
                    Icons.notifications,
                    color: entry.notification ?  Color(0xFFFFDC00) : Color(0xFFD9D9D9),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 4,
                  height: 56,
                  decoration: BoxDecoration(
                    color: getCategoryColor(entry.category),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(8), topLeft: Radius.circular(8),)
                  ),
                ),
              ),
              Positioned(
                top: 21,
                left: 52,
                child:Text(
                  "${DateFormat("HH:mm").format(entry.targetDate)}",
                  style: const TextStyle(fontSize: 12, color: Color(0xFFC6C6C8)),
                ),
              )
            ],
          ),
        ),
      ),
      secondaryActions: [
        GestureDetector(
          onTap: (){
            showEditDialog(context);
          },
          child: Container(
            width: 36,
            height: 44,
            margin: EdgeInsets.only(left: 12, bottom: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Color(0xFFC4CEF5)
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/edit.svg",
                width: 18,
                height: 17,
                color: Color(0xFF5F87E7),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            BlocProvider.provideBloc(context).deleteEntry(entry);
          },
          child: Container(
            width: 36,
            height: 44,
            margin: EdgeInsets.only(left: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Color(0xFFFFCFCF)
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/trash.svg",
                width: 15,
                height: 16,
                color: Color(0xFFFB3636),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showEditDialog(BuildContext context){
    TodoEntry todoEntry  = entry;

    updateEntry(TodoEntry entry){
      todoEntry = entry;
    }

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(localisedString(context, 'edit_entry')),
            scrollable: true,
            content: DialogContent(entry: entry, updateEntry: updateEntry, textEditingController: textController, categories: categories,),
            actions: [
              FlatButton(
                child: Text(localisedString(context, 'cancel')),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(localisedString(context, 'save')),
                onPressed: () {
                  todoEntry = todoEntry.copyWith(
                    content: textController.text.isNotEmpty? textController.text : entry.content,
                  );
                  BlocProvider.provideBloc(context).updateEntry(todoEntry);
                  Navigator.pop(context);
                },
              ),
            ],
          )
    );
  }
}

class DialogContent extends StatefulWidget {
  final TodoEntry entry;
  final TextEditingController textEditingController;
  final Function updateEntry;
  final List<Category> categories;

  DialogContent({this.entry, this.textEditingController, this.updateEntry, this.categories});

  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  final DateTime dateTime = DateTime.now();
  TodoEntry todoEntry;

  changePos(int pos){
    setState(() {
      todoEntry = todoEntry.copyWith(category: pos);
      widget.updateEntry(todoEntry);
    });
  }

  bool isToday(){
    return dateTime.day == todoEntry.targetDate.day && dateTime.month == todoEntry.targetDate.month && dateTime.year == todoEntry.targetDate.year;
  }

  @override
  void initState() {
    super.initState();
    todoEntry = widget.entry;
    widget.textEditingController.text = todoEntry.content;
  }

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).toString();
    LocaleType localeType;
    switch(locale){
      case 'en': localeType = LocaleType.en; break;
      case 'ru': localeType = LocaleType.ru; break;
      case 'uz': localeType = LocaleType.uz; break;
    }

    return  Container(
      height: 256,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.textEditingController,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            cursorWidth: 2,
            cursorRadius: Radius.circular(1),
            cursorColor: Color(0xFF373737),
            style: TextStyle(
              color: Color(0xFF373737),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Wrap(
            children: [
              for(int i =0; i< widget.categories.length; i++)
                  ItemEditCategory(
                  category: widget.categories[i],
                  changePos: changePos,
                  pos: todoEntry.category,
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 9),
            child: Divider(
              height: 1,
              color: Color(0xFFCFCFCF),
            ),
          ),
          InkWell(
            onTap: (){
              DatePicker.showDateTimePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
                onChanged: (date) {
                  print('changeDate: $date');
                },
                onConfirm: (date) {
                  setState(() {
                    todoEntry = todoEntry.copyWith(targetDate: date);
                    widget.updateEntry(todoEntry);
                  });
                },
                currentTime: todoEntry.targetDate,
                locale: localeType,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  isToday() ? "${localisedString(context, 'today')}, ${todoEntry.targetDate.hour.toString().padLeft(2, '0')} : ${todoEntry.targetDate.minute.toString().padLeft(2, '0')}" : "${localisedString(context, "month_${todoEntry.targetDate.month}")} ${todoEntry.targetDate.day}, ${todoEntry.targetDate.hour.toString().padLeft(2, '0')} : ${todoEntry.targetDate.minute.toString().padLeft(2, '0')}",
                  style: titleTextStyle.copyWith(fontWeight: FontWeight.w600, color: Color(0xFF404040)),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: SvgPicture.asset(
                    'assets/svg/following.svg',
                    height: 12,
                    width: 12,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
