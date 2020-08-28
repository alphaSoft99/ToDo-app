import 'package:flutter/material.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'package:todo/ui/common/category_item.dart';
import 'package:todo/ui/main/navigation.dart';

class TasksPage extends StatelessWidget {

  final TodoAppBloc bloc;
  final MainNotifier mainNotifier;
  final List<Category> categories;

  TasksPage({this.bloc, this.mainNotifier, this.categories});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CategoryWithActiveInfo>>(
      stream: bloc.categories,
      builder: (context, snapshot) {
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: mainNotifier.isOpen? 80: 16),
          childAspectRatio: 1.6 / 1.8,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(snapshot.hasData? 6: 0, (index){
              return CategoryItem(categoryWithCount: snapshot.data[index].categoryWithCount, categories: categories, bloc: bloc,);
          }),
        );
      },
    );
  }
}
