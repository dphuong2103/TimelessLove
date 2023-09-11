// ignore_for_file: constant_identifier_names
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color.fromRGBO(239, 239, 239, 1);
const COLOR_ACCENT = Color.fromRGBO(128, 131, 255, 1);

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  toggleThemeMode() => _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  get themeMode => _themeMode;

  ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: COLOR_PRIMARY,
    primaryColor: COLOR_PRIMARY,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: COLOR_PRIMARY, elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.grey.shade700,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
      ),
      // color: Colors.black,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: COLOR_PRIMARY,
      primary: COLOR_ACCENT,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: COLOR_ACCENT,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static get appTitleTheme => GoogleFonts.dancingScript(
        fontSize: 45,
        fontWeight: FontWeight.bold,
      );

  static get pageTitleTheme => GoogleFonts.inconsolata(
        fontSize: 40,
      );
}
