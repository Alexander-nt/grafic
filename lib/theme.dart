import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

ThemeData customTheme(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primaryColor: brightness == Brightness.light
        ? Colors.red // Для светлой темы
        : Colors.lightBlue, // Для темной темы

    scaffoldBackgroundColor: brightness == Brightness.light
        ? Colors.white // Фон для светлой темы
        : Colors.black, // Фон для темной темы

    appBarTheme: AppBarTheme(
      toolbarHeight: 70.0, // Высота AppBar
      backgroundColor: brightness == Brightness.light
          ? Colors.white // Фон AppBar для светлой темы
          : Colors.black, // Фон AppBar для темной темы
      foregroundColor: brightness == Brightness.light
          ? Colors.black // Текст и иконки для светлой темы
          : Colors.white, // Текст и иконки для темной темы
      centerTitle: true, // Центрирование текста
      titleTextStyle: GoogleFonts.notoSerif(// Шрифт текста AppBar
        fontSize: 48,
        color: brightness == Brightness.light
            ? Colors.black // Текст AppBar для светлой темы
            : Colors.white, // Текст AppBar для темной темы
      ),
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
            fontSize: 25,
      ),
      displaySmall: TextStyle(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
            fontSize: 15,
      ),
      titleLarge: TextStyle(// Текст бригады
        fontSize: 20,
        color: brightness == Brightness.light
            ? Colors.grey[600] // Текст бригады (светлая тема)
            : Colors.grey[400], // Текст бригады (темная тема)
      ),
      titleMedium: TextStyle(// Текст смены
        fontSize: 18,
        color: brightness == Brightness.light
            ? Colors.black // Текст смены (светлая тема)
            : Colors.white, // Текст смены (темная тема)
      ),
    ),
  );
}

extension CalendarTheme on ThemeData {
  CalendarStyle get calendarStyle => CalendarStyle(
        todayDecoration: BoxDecoration(// Цвет выделения текущего дня
          color: brightness == Brightness.light
              ? Colors.green // Для светлой темы
              : Colors.green, // Для темной темы
          shape: BoxShape.circle,// Круглая форма для дня
        ),
        selectedDecoration: BoxDecoration(// Цвет выделения выбранного дня
          color: brightness == Brightness.light
              ? Colors.blueAccent // Светлая тема
              : Colors.blueAccent, // Темная тема
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(// Цвет для дней текущего месяца
          color: brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(// Цвет текста для обычных дней
          color: brightness == Brightness.light
              ? Colors.black // Текст для светлой темы
              : Colors.white, // Текст для темной темы
        ),
        weekendDecoration: BoxDecoration(// Цвет для выходных дней
          color: brightness == Brightness.light
              ? Colors.white
              : Colors.black12,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: TextStyle(// Цвет текста выходных дней
          color: brightness == Brightness.light
              ? Colors.red // Выходные для светлой темы
              : Colors.orange, // Выходные для темной темы
        ),
        // outsideDecoration: const BoxDecoration(
        //   color: Colors.grey, // Цвет для дней вне текущего месяца
        //   shape: BoxShape.circle,
        // ),
        outsideTextStyle: TextStyle(// Цвет текста для дней вне текущего месяца
          color: brightness == Brightness.light
              ? Colors.black26 // Дни вне месяца (светлая тема)
              : Colors.white24, // Дни вне месяца (темная тема)
        ),
      );


  HeaderStyle get headerStyle => const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        
        titleTextStyle: TextStyle(
          fontSize: 20,
          // fontWeight: FontWeight.bold,
          // color: Colors.black,
        ),
      );
}