import 'package:flutter/material.dart';

final TextStyle fadedTextStyle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w500,
  color: textColor,
);

final TextStyle categoryTextStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w500,
  color: Color(0xFF686868),
);

final TextStyle subCategoryTextStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.w400,
  color: Color(0xFFA1A1A1),
);

final TextStyle titleTextStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.w500,
  color: textColor,
);

final TextStyle doneTextStyle = TextStyle(
  fontSize: 14.0,
  decoration: TextDecoration.lineThrough,
  fontWeight: FontWeight.w400,
  color: Color(0xFFD9D9D9),
);

final TextStyle subFadedTextStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.w400,
  color: Color(0xFF82A0B7),
);

final TextStyle buttonTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: whiteColor,
);

final TextStyle whiteHeadingTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: whiteColor,
);

final TextStyle subtitleHeadingTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Color(0xFFF3F3F3),
);


final TextStyle categoryTitleTextStyle = categoryTextStyle.copyWith(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: Color(0xFF8E8E8E),
);

final TextStyle selectedCategoryTitleTextStyle = categoryTitleTextStyle.copyWith(
  color: Color(0xFFFFFFFF),
);

final TextStyle bottomBarTextStyle = TextStyle(
  fontSize: 10.0,
  fontWeight: FontWeight.w500,
  color: Color(0xFF5F87E7),
);

Color textColor = Color(0xFF554E8F);
Color whiteColor = Color(0xFFFFFFFF);
Color backgroundColor = Color(0xFFF9FCFF);
Color personColor = Color(0xFFF9C229);
Color workColor = Color(0xFF1ED102);
Color meetingColor = Color(0xFFD10263);
Color shoppingColor = Color(0xFFEC6C0B);
Color partyColor = Color(0xFF09ACCE);
Color studyColor = Color(0xFFBF0080);