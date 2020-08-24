import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:todo/blocs/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/styleguide.dart';
/// Card that displays an entry and an icon button to delete that entry
class TodoCard extends StatelessWidget {
  final TodoEntry entry;

  TodoCard(this.entry) : super(key: ObjectKey(entry.id));

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
        Container(
          width: 36,
          height: 44,
          margin: EdgeInsets.only(left: 12, bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xFFFFCFCF)
          ),
          child: InkWell(
            onTap: (){
              BlocProvider.provideBloc(context).deleteEntry(entry);
            },
            child: Center(
              child: SvgPicture.asset(
                "assets/svg/trash.svg",
                width: 15,
                height: 16,
                color: Color(0xFFFB3636),
              ),
            ),
          ),
        )
      ],
    );
  }
}