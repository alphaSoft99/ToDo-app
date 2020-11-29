import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/blocs/bloc.dart';
import 'package:todo/blocs/provider.dart';
import 'package:todo/ui/home/home_page.dart';
import 'package:todo/ui/main/appbar_notification.dart';
import 'package:todo/ui/main/bottom_naviagtion_bar.dart';
import 'package:todo/ui/main/main_appbar_background.dart';
import 'package:todo/ui/main/navigation.dart';
import 'package:todo/ui/splash.dart';
import 'package:todo/ui/task/tasks_page.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';
import 'my_floating_action_button.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return MainPageState();
  }
}

/// Shows a list of todos and displays a text input to add another one
class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // we only use this to reset the input field at the bottom when a entry has been added
  final TextEditingController controller = TextEditingController();
  AnimationController _animationController;
  Animation<double> _animation;

  TodoAppBloc get bloc => BlocProvider.provideBloc(context);

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    _animation =
        Tween<double>(begin: 100, end: 220).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    final mainNotifier = Provider.of<MainNotifier>(context);
    return StreamBuilder<NotificationDataWithTasksCount>(
      stream: bloc.mainData,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          mainNotifier.changeNotification(snapshot.data.todoEntry.isNotEmpty);
          if (snapshot.data.todoEntry != null && mainNotifier.showNotification) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        }
        if (snapshot.hasData) {
          return Stack(
                children: [
                  Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(_animation.value),
                      child: Container(
                        height: _animation.value,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF3867D5),
                                Color(0xFF81C7F5),
                              ]),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 44, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localisedString(context, 'hello'),
                                style: subFadedTextStyle.copyWith(
                                    color: whiteColor),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "${localisedString(context, 'today_you_have')} ${snapshot.data.tasks.isNotEmpty ? "${snapshot.data.tasks.length}" : "${localisedString(context, 'no')}"} ${localisedString(context, '_tasks')}!",
                                style: subFadedTextStyle.copyWith(
                                    color: whiteColor, fontSize: 12),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              mainNotifier.showNotification ? AppBarNotification(
                                mainNotifier: mainNotifier,
                                      todoEntry: snapshot.data.todoEntry[0],
                              ) : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: IndexedStack(
                      children: [
                        HomePage(bloc: bloc, mainNotifier: mainNotifier, categories: snapshot.data.categories,),
                        TasksPage(bloc: bloc, mainNotifier: mainNotifier, categories: snapshot.data.categories,),
                      ],
                      index: mainNotifier.index,
                    ),
                    bottomNavigationBar: Visibility(
                      visible: !mainNotifier.isOpen,
                      child: BottomNavBar(
                              mainNotifier: mainNotifier,
                            ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    floatingActionButton: MyFloatingActionButton(
                      bloc: bloc,
                      mainNotifier: mainNotifier,
                      categories: snapshot.data.categories,
                    ),
                  ),
                  MainAppBarBackground(),
                ],
              );
        } else {
          return Splash();
        }
      },
    );
  }
}
