import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final darkTheme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.muliTextTheme(),
  scaffoldBackgroundColor: InstagramColors.scaffoldDark,
  accentColor: InstagramColors.cardLight,
  cardColor: InstagramColors.cardDark,
  textSelectionColor: InstagramColors.pink,

  //canvasColor: InstagramColors.cardLight,
  dividerColor: InstagramColors.categoryDark,
  hintColor: InstagramColors.cardLight,
  brightness: Brightness.light,
);

final lightTheme = ThemeData.light().copyWith(
  textTheme: GoogleFonts.muliTextTheme(),
  scaffoldBackgroundColor: InstagramColors.scaffoldLigth,
  accentColor: InstagramColors.grey,
  cardColor: InstagramColors.cardLight,
  textSelectionColor: InstagramColors.pink,
  //canvasColor: InstagramColors.pink,
  dividerColor: InstagramColors.categoryLight,
  hintColor: InstagramColors.colorHistoryLight,
  brightness: Brightness.dark,
);



class InstagramColors {
  static final Color blue = Color(0xFF1B29C6);
  static final Color purple = Color(0xFF8134AF);
  static final Color pink = Color(0xFFDD2A7B);
  static final Color yellow = Color(0xFFFDEA77);
  static final Color orange = Color(0xFFF58529);
  static final Color grey = Color(0xFFBABABA);
  static final Color scaffoldDark = Color(0xFF181818);
  static final Color scaffoldLigth = Color(0xFFF0F1F5);
  static final Color cardDark = Color(0xFF31323B);
  static final Color cardLight = Color(0xFFFFFFFF);
  static final Color categoryLight = Color(0xFFB5B5B5);
  static final Color categoryDark = Color(0xFF434343);
  static final Color colorHistoryLight = Color(0xFF909090);
}







    //bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    