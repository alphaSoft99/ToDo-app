import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo/main.dart';
import 'package:todo/utils/language_constants.dart';
import 'package:todo/utils/style_guide.dart';

class ChangeLanguagePage extends StatefulWidget {

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  bool _langUzbekSelected = false;
  bool _langRussianSelected = false;
  bool _langEnglishSelected = false;

  final Widget uzbWidget = SvgPicture.asset(
    'assets/svg/uzbekistan.svg',
    semanticsLabel: 'Uzbekistan Flag',
    width: 24,
    height: 24,
  );
  final Widget rusWidget = SvgPicture.asset(
    'assets/svg/russia.svg',
    semanticsLabel: 'Russian Flag',
    width: 24,
    height: 24,
  );
  final Widget engWidget = SvgPicture.asset(
    'assets/svg/english.svg',
    semanticsLabel: 'English Flag',
    width: 24,
    height: 24,
  );

  @override
  Widget build(BuildContext context) {
    var locale = Localizations.localeOf(context).toString();
    _langRussianSelected = locale == "ru";
    _langUzbekSelected = locale == "uz";
    _langEnglishSelected = locale == "en";

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
        backgroundColor: Color(0xFF81C7F5),
//          title: Text(localisedString(context, 'language'), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17)),
      ),
      body: _buildBody(),
      backgroundColor: whiteColor,
    );
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    Locale _locale = await setLocale(languageCode);
    Main.setLocale(context, _locale);
  }

  Widget _buildBody() {
    return Builder(
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Column(
            children: [
              ListTile(
                onTap: () => {_changeLanguage(context, 'uz')},
                leading: uzbWidget,
                title: Text(
                  'O’zbek',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                trailing: Visibility(
                  child: Icon(Icons.done, color: Color(0xFFFF0006), size: 24.0),
                  visible: _langUzbekSelected,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () => {_changeLanguage(context, 'ru')},
                leading: rusWidget,
                title: Text(
                  'Русский',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                trailing: Visibility(
                  child: Icon(Icons.done, color: Color(0xFFFF0006), size: 24.0),
                  visible: _langRussianSelected,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () => {_changeLanguage(context, 'en')},
                leading: engWidget,
                title: Text(
                  'English',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0),
                ),
                trailing: Visibility(
                  child: Icon(Icons.done, color: Color(0xFFFF0006), size: 24.0),
                  visible: _langEnglishSelected,
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
