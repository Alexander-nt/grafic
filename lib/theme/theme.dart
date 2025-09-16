import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

ThemeData customTheme(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primaryColor: brightness == Brightness.light
        ? Colors.white // Для светлой темы
        : Colors.black, // Для темной темы

    // dialogBackgroundColor: brightness == Brightness.light
    //     ? Colors.white // Фон для светлой темы
    //     : Colors.black, // Ф,

    scaffoldBackgroundColor: brightness == Brightness.light
        ? Colors.white // Фон для светлой темы
        : Colors.black, // Фон для темной темы

    appBarTheme: AppBarTheme(
      // toolbarHeight: 30, // Высота AppBar
      backgroundColor: brightness == Brightness.light
          ? Colors.white // Фон AppBar для светлой темы
          : Colors.black, // Фон AppBar для темной темы
      foregroundColor: brightness == Brightness.light
          ? Colors.black // Текст и иконки для светлой темы
          : Colors.white, // Текст и иконки для темной темы
      centerTitle: true, // Центрирование текста
      titleTextStyle: GoogleFonts.notoSerif(
        // Шрифт текста AppBar
        fontSize: 30,
        color: brightness == Brightness.light
            ? Colors.black // Текст AppBar для светлой темы
            : Colors.white, // Текст AppBar для темной темы
      ),
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.notoSerif(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
        fontSize: 30,
      ),
      displayLarge: TextStyle(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
        fontSize: 20,
      ),
      // labelLarge: TextStyle(
      //   color: brightness == Brightness.light
      //       ? Colors.black // Цвет текста для светлой темы
      //       : Colors.white, // Цвет текста для темной темы
      //       fontSize: 35,
      // ),
      displayMedium: TextStyle(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
        fontSize: 18,
      ),
      displaySmall: TextStyle(
        color: brightness == Brightness.light
            ? Colors.black // Цвет текста для светлой темы
            : Colors.white, // Цвет текста для темной темы
        fontSize: 16,
      ),
      titleLarge: TextStyle(
        // Текст название бригады
        fontSize: 20,
        color: brightness == Brightness.light
            ? Colors.grey[600] // Текст бригады (светлая тема)
            : Colors.grey[400], // Текст бригады (темная тема)
      ),
      titleMedium: TextStyle(
        // Текст смены
        fontSize: 18,
        color: brightness == Brightness.light
            ? Colors.black // Текст смены (светлая тема)
            : Colors.white, // Текст смены (темная тема)
      ),
      headlineSmall: TextStyle(
        // Текст кнопки
        fontSize: 15,
        color: brightness == Brightness.light
            ? Colors.black // Текст смены (светлая тема)
            : Colors.white, // Текст смены (темная тема)
      ),
    ),
    useMaterial3: true,
  );
}

extension CalendarTheme on ThemeData {
  CalendarStyle get calendarStyle => CalendarStyle(
        todayDecoration: BoxDecoration(
          // Цвет выделения текущего дня
          color: brightness == Brightness.light
              ? Colors.green // Для светлой темы
              : Colors.green, // Для темной темы
          shape: BoxShape.circle, // Круглая форма для дня
        ),
        todayTextStyle: TextStyle(
          //Текст выделения текущего дня
          color: brightness == Brightness.light
              ? Colors.black // Текст для светлой темы
              : Colors.white, // Текст для темной темы
          fontSize: 18,
        ),
        selectedDecoration: BoxDecoration(
          // Цвет выделения выбранного дня
          color: brightness == Brightness.light
              ? Colors.blueAccent // Светлая тема
              : Colors.blueAccent, // Темная тема
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(
          //Текст выделения выбранного дня
          color: brightness == Brightness.light
              ? Colors.black // Текст для светлой темы
              : Colors.white, // Текст для темной темы
          fontSize: 23,
        ),

        defaultDecoration: BoxDecoration(
          // Цвет для дней текущего месяца
          color:
              brightness == Brightness.light ? Colors.black12 : Colors.white12,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(
          //Текст для обычных дней
          color: brightness == Brightness.light
              ? Colors.black // Текст для светлой темы
              : Colors.white, // Текст для темной темы
          // fontSize: 12,
        ),

        // weekendDecoration: BoxDecoration(// Цвет для выходных дней
        //   color: brightness == Brightness.light
        //       ? Colors.white
        //       : Colors.black12,
        //   shape: BoxShape.circle,
        // ),
        // weekendTextStyle: TextStyle(// Цвет текста выходных дней
        //   color: brightness == Brightness.light
        //       ? Colors.red // Выходные для светлой темы
        //       : Colors.orange, // Выходные для темной темы
        // ),
        // outsideDecoration: const BoxDecoration(
        //   color: Colors.grey, // Цвет для дней вне текущего месяца
        //   shape: BoxShape.circle,
        // ),
        outsideTextStyle: TextStyle(
          // Цвет текста для дней вне текущего месяца
          color: brightness == Brightness.light
              ? Colors.black26 // Дни вне месяца (светлая тема)
              : Colors.white24, // Дни вне месяца (темная тема)
        ),
      );

  CalendarBuilders get calendarStyle2 => CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final provider = context.watch<AppDataProvider>();
          Color shiftColor = provider.colorsShift(day, focusedDay);
          if (provider.shiftsColrlight == true) {
            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: shiftColor,
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          }
          return null;
        },
        todayBuilder: (context, day, focusedDay) {
          final provider = context.watch<AppDataProvider>();
          Color shiftColor = provider.colorsShift(day, focusedDay);
          if (provider.shiftsColrlight == true) {
            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: shiftColor,
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            );
          }
          return null;
        },
        selectedBuilder: (context, day, focusedDay) {
          final provider = context.watch<AppDataProvider>();
          // Color shiftColor = provider.colorsShift(day, focusedDay);
          if (provider.shiftsColrlight == true) {
            return Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: brightness == Brightness.light
              ? Colors.black // Текст для светлой темы
              : Colors.white, // Текст для темной темы
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: brightness == Brightness.light
              ? Colors.white // Текст для светлой темы
              : Colors.black, // Текст для темной темы
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            );
          }
          return null;
        },
      );

  HeaderStyle get headerStyle => const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        formatButtonShowsNext: true,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 23,
          // fontWeight: FontWeight.bold,
          // color: Colors.black,
        ),
      );
}
