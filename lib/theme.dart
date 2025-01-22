import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

// Светлая тема
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white, // Фон для светлой темы

  appBarTheme: AppBarTheme(
    toolbarHeight: 100.0, // Высота AppBar
    backgroundColor: Colors.white, // Фон AppBar
    foregroundColor: Colors.black, // Цвет текста и иконок
    centerTitle: true, // Центрирование текста
    titleTextStyle: GoogleFonts.notoSerif(
      fontSize: 48,
      color: Colors.black,
    ),
  ),

  textTheme: const TextTheme(
    // bodyLarge: TextStyle(color: Colors.blue), // Цвет основного текста
    bodySmall: TextStyle(color: Colors.black12), // Цвет вторичного текста
    // bodyMedium: TextStyle(color: Colors.black),
  ),
);

// Темная тема
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black, // Фон для темной темы

  appBarTheme: AppBarTheme(
    toolbarHeight: 100.0, // Высота AppBar
    backgroundColor: Colors.black, // Фон AppBar
    foregroundColor: Colors.white, // Цвет текста и иконок
    centerTitle: true, // Центрирование текста
    titleTextStyle: GoogleFonts.notoSerif(
      fontSize: 48,
      color: Colors.white,
    ),
  ),

  textTheme: const TextTheme(
    // bodyLarge: TextStyle(color: Colors.blue), // Цвет основного текста
    bodySmall: TextStyle(color: Colors.white12), // Цвет вторичного текста
    // bodyMedium: TextStyle(color: Colors.red),
  ),
);

extension CalendarTheme on ThemeData {
  CalendarStyle get calendarStyle => CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        defaultDecoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        // defaultTextStyle: textTheme.bodyMedium!.copyWith(
        //   color: Colors.black, // Цвет текста для обычных дней
        // ),
        weekendDecoration: const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        // weekendTextStyle: textTheme.bodyMedium!.copyWith(
        //   color: Colors.red, // Цвет текста выходных дней
        // ),
        // outsideDecoration: const BoxDecoration(
        //   color: Colors.grey,
        //   shape: BoxShape.circle,
        // ),
        outsideTextStyle: textTheme.bodySmall!.copyWith(
          // color: Colors.blueGrey, // Цвет текста для дней вне текущего месяца
        ),
      );

  HeaderStyle get headerStyle => const HeaderStyle(
        // formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          // fontWeight: FontWeight.bold,
          // color: Colors.black,
        ),
      );
}