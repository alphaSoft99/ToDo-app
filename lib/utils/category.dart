import 'dart:ui';

import 'package:todo/utils/styleguide.dart';

enum Categorys { personal, work, meeting, shopping, party, study }

Color getCategoryColor(int index) {
  Color color;
  switch (Categorys.values[index]) {
    case Categorys.personal:
      color = personColor;
      break;
    case Categorys.work:
      color = workColor;
      break;
    case Categorys.meeting:
      color = meetingColor;
      break;
    case Categorys.shopping:
      color = shoppingColor;
      break;
    case Categorys.party:
      color = partyColor;
      break;
    case Categorys.study:
      color = studyColor;
      break;
  }
  return color;
}

String getCategoryText(int index) {
  String text;
  switch (Categorys.values[index]) {
    case Categorys.personal:
      text= "Personal";
      break;
    case Categorys.work:
      text = "Work";
      break;
    case Categorys.meeting:
      text = "Meeting";
      break;
    case Categorys.shopping:
      text = "Shopping";
      break;
    case Categorys.party:
      text = "Party";
      break;
    case Categorys.study:
      text = "Study";
      break;
  }
  return text;
}

String getCategoryImage(int index) {
  String path;
  switch (Categorys.values[index]) {
    case Categorys.personal:
      path = "assets/svg/user.svg";
      break;
    case Categorys.work:
      path = "assets/svg/briefcase.svg";
      break;
    case Categorys.meeting:
      path = "assets/svg/presentation.svg";
      break;
    case Categorys.shopping:
      path = "assets/svg/shopping_basket.svg";
      break;
    case Categorys.party:
      path = "assets/svg/confetti.svg";
      break;
    case Categorys.study:
      path = "assets/svg/molecule.svg";
      break;
  }
  return path;
}
