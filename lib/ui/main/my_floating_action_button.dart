import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/database/database.dart';
import 'dart:math' as math;
import 'add_task_sheet.dart';
import 'navigation.dart';

class MyFloatingActionButton extends StatelessWidget {

  final MainNotifier mainNotifier;
  final TodoAppBloc bloc;
  final List<Category> categories;
  MyFloatingActionButton({this.mainNotifier, this.bloc, this.categories});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if(mainNotifier.isOpen){
          mainNotifier.changeBottomSheet(false);
          Navigator.pop(context);
        }
        else {
          final bottomSheetController = showBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => AddTaskSheet(
                bloc: bloc,
                categoryId: mainNotifier.categoryId,
                categories: categories,
              ));
          mainNotifier.changeBottomSheet(true);
          bottomSheetController.closed.then((value) {
            mainNotifier.changeBottomSheet(false);
          });
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF857C3),
                    Color(0xFFE0139C),
                  ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: - math.pi / (mainNotifier.isOpen? 4 : 1),
              child: SvgPicture.asset(
                "assets/svg/add.svg",
                height: 24,
                width: 24,
              ),
            ),
          )
        ],
      ),
    );
  }
}
