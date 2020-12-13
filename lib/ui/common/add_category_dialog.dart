import 'package:flutter/material.dart';
import 'package:todo/utils/language_constants.dart';


//TODO 2-version add category
class AddCategoryDialog extends StatefulWidget {
  @override
  _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                localisedString(context, 'add_category'),
                style: Theme.of(context).textTheme.title,
              ),
            ),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                labelText: localisedString(context, 'name_category'),
              ),
              onSubmitted: (_) => _addEntry(),
            ),
            ButtonBar(
              children: [
                FlatButton(
                  child: Text(localisedString(context, 'add')),
                  textColor: Theme.of(context).accentColor,
                  onPressed: _addEntry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addEntry() {
  }
}
