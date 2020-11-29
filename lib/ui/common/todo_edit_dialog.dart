import 'package:flutter/material.dart';
import 'package:todo/blocs/provider.dart';
import 'package:todo/database/database.dart';
import 'package:todo/utils/language_constants.dart';

class TodoEditDialog extends StatefulWidget {
  final TodoEntry entry;

  const TodoEditDialog({Key key, this.entry}) : super(key: key);

  @override
  _TodoEditDialogState createState() => _TodoEditDialogState();
}

class _TodoEditDialogState extends State<TodoEditDialog> {
  final TextEditingController textController = TextEditingController();
  DateTime _dueDate;

  @override
  void initState() {
    textController.text = widget.entry.content;
    _dueDate = widget.entry.targetDate;
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localisedString(context, 'edit_entry')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: localisedString(context, 'what_need'),
              helperText: localisedString(context, 'content_of_entry'),
            ),
          ),
          Row(
            children: <Widget>[
              Text(localisedString(context, 'formatted_date')),
              Spacer(),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final now = DateTime.now();
                  final initialDate = _dueDate ?? now;
                  final firstDate =
                      initialDate.isBefore(now) ? initialDate : now;

                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstDate,
                    lastDate: DateTime(3000),
                  );

                  setState(() {
                    if (selectedDate != null) _dueDate = selectedDate;
                  });
                },
              ),
            ],
          ),
        ],
      ),
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
            final updatedContent = textController.text;
            final entry = widget.entry.copyWith(
              content: updatedContent.isNotEmpty ? updatedContent : null,
              targetDate: _dueDate,
            );
            BlocProvider.provideBloc(context).updateEntry(entry);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
