import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:todo/database/database.dart';
import 'package:todo/database/database/mobile.dart';
import 'package:todo/ui/main/mian_page.dart';
import 'package:todo/ui/main/navigation.dart';
import 'package:todo/utils/category.dart';
import 'package:todo/utils/style_guide.dart';
import 'package:todo/utils/translations.dart';
import 'package:todo/utils/language_constants.dart';
import 'blocs/bloc.dart';
import 'blocs/provider.dart';
import 'plugins/desktop/desktop.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print("[BackgroundFetch] Headless event received: $taskId");

  BackgroundFetch.finish(taskId);

  if (taskId == 'alpha.soft.todo') {
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "alpha.soft.todo",
        delay: 60000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true
    )).then((value) async {
      final now = DateTime.now();
      final Database db =constructDb(logStatements: true);
      final todoEntries = await db.getEntry(DateTime(now.year, now.month, now.day, now.hour, now.minute, 0, 0, 0));
      final entry = todoEntries.isNotEmpty? todoEntries[0] : null;
      if(entry!=null){
        String lang = await getLanguage();
        String category = '';
        switch(lang){
          case 'uz': category = getCategoryTextUz(entry.category); break;
          case 'ru': category = getCategoryTextRu(entry.category); break;
          case 'en': category = getCategoryTextEn(entry.category); break;
        }
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'ToDo', 'ToDo notification', 'The notification reminds you of tasks',
            importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
        var platformChannelSpecifics = NotificationDetails(
            androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(entry.id, category, entry.content, platformChannelSpecifics,
            payload: 'item x');
      }
      db.close();
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload);
      });
  setTargetPlatformForDesktop(platform: TargetPlatform.android);
  runApp(Main());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MainState state = context.findAncestorStateOfType<_MainState>();
    state.setLocale(newLocale);
  }
}

class _MainState extends State<Main> {
  TodoAppBloc bloc;
  Locale _locale = Locale('en', '');

  @override
  void initState() {
    super.initState();
    bloc = TodoAppBloc();
    initPlatformState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();

    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 1440,
      forceAlarmManager: false,
      stopOnTerminate: false,
      startOnBoot: true,
      enableHeadless: true,
      requiresBatteryNotLow: false,
      requiresCharging: false,
      requiresStorageNotLow: false,
      requiresDeviceIdle: false,
      requiredNetworkType: NetworkType.NONE,
    ), _onBackgroundFetch).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // Schedule a "one-shot" custom-task in 10000ms.
    // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
    // where device must be powered (and delay will be throttled by the OS).
    BackgroundFetch.scheduleTask(TaskConfig(
        taskId: "alpha.soft.todo",
        delay: 60000,
        periodic: false,
        forceAlarmManager: true,
        stopOnTerminate: false,
        enableHeadless: true
    )).then((value) => {
      print(value)
    });


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetch(String taskId) async {
    // This is the fetch-event callback.

    if (taskId == "alpha.soft.todo") {
      // Schedule a one-shot task when fetch event received (for testing).
      BackgroundFetch.scheduleTask(TaskConfig(
          taskId: "alpha.soft.todo",
          delay: 60000,
          periodic: false,
          forceAlarmManager: true,
          stopOnTerminate: false,
          enableHeadless: true
      )).then((value) async {
        /*final now = DateTime.now();
        final todoEntry = await bloc.db.getEntry(now);
        if(todoEntry != null && todoEntry.targetDate.hour == now.hour && todoEntry.targetDate.minute == now.minute){
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'your channel id', 'your channel name', 'your channel description',
              importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
          var iOSPlatformChannelSpecifics = IOSNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(todoEntry.id, getCategoryText(todoEntry.category), todoEntry.content, platformChannelSpecifics,
              payload: 'item x');
        }*/
      });
    }


    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    //BackgroundFetch.finish(taskId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'ToDo',
        theme: ThemeData(
          fontFamily: "Rubik",
          backgroundColor: backgroundColor,
          // ignore: deprecated_member_use
          typography: Typography(
            englishLike: Typography.englishLike2018,
            dense: Typography.dense2018,
            tall: Typography.tall2018,
          ),
        ),
        localizationsDelegates: [
          TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        locale: _locale,
        supportedLocales: [
          const Locale('ru', ''),
          const Locale('uz', ''),
          const Locale('en', ''),
        ],
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MainNotifier()),
          ],
          child: MainPage(),
        ),
      ),
    );
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }


  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(localisedString(context, 'ok')),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Main(),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Main()));
    });
  }

/*
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(localisedString(context, 'ok')),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Main(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) => Main()),);
  }
*/
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
