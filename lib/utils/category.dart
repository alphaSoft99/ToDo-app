import 'dart:ui';

import 'package:todo/utils/styleguide.dart';

enum Categories { personal, work, meeting, shopping, party, study }

Color getCategoryColor(int index) {
  Color color;
  switch (Categories.values[index]) {
    case Categories.personal:
      color = personColor;
      break;
    case Categories.work:
      color = workColor;
      break;
    case Categories.meeting:
      color = meetingColor;
      break;
    case Categories.shopping:
      color = shoppingColor;
      break;
    case Categories.party:
      color = partyColor;
      break;
    case Categories.study:
      color = studyColor;
      break;
  }
  return color;
}

String getCategoryText(int index) {
  String text;
  switch (Categories.values[index]) {
    case Categories.personal:
      text= "personal";
      break;
    case Categories.work:
      text = "work";
      break;
    case Categories.meeting:
      text = "meeting";
      break;
    case Categories.shopping:
      text = "shopping";
      break;
    case Categories.party:
      text = "party";
      break;
    case Categories.study:
      text = "study";
      break;
  }
  return text;
}

String getCategoryTextUz(int index) {
  String text;
  switch (Categories.values[index]) {
    case Categories.personal:
      text= "Shaxsiy";
      break;
    case Categories.work:
      text = "Ish";
      break;
    case Categories.meeting:
      text = "Uchrashuv";
      break;
    case Categories.shopping:
      text = "Savdo";
      break;
    case Categories.party:
      text = "Bayram";
      break;
    case Categories.study:
      text = "O'qish";
      break;
  }
  return text;
}


String getCategoryTextRu(int index) {
  String text;
  switch (Categories.values[index]) {
    case Categories.personal:
      text= "Личное";
      break;
    case Categories.work:
      text = "Работа";
      break;
    case Categories.meeting:
      text = "Встреча";
      break;
    case Categories.shopping:
      text = "Покупки";
      break;
    case Categories.party:
      text = "Праздник";
      break;
    case Categories.study:
      text = "Обучение";
      break;
  }
  return text;
}

String getCategoryTextEn(int index) {
  String text;
  switch (Categories.values[index]) {
    case Categories.personal:
      text= "Personal";
      break;
    case Categories.work:
      text = "Work";
      break;
    case Categories.meeting:
      text = "Meeting";
      break;
    case Categories.shopping:
      text = "Shopping";
      break;
    case Categories.party:
      text = "Party";
      break;
    case Categories.study:
      text = "Study";
      break;
  }
  return text;
}

String getCategoryImage(int index) {
  String path;
  switch (Categories.values[index]) {
    case Categories.personal:
      path = "assets/svg/user.svg";
      break;
    case Categories.work:
      path = "assets/svg/briefcase.svg";
      break;
    case Categories.meeting:
      path = "assets/svg/presentation.svg";
      break;
    case Categories.shopping:
      path = "assets/svg/shopping_basket.svg";
      break;
    case Categories.party:
      path = "assets/svg/confetti.svg";
      break;
    case Categories.study:
      path = "assets/svg/molecule.svg";
      break;
  }
  return path;
}
