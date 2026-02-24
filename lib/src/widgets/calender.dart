import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafic/import.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class Calender extends StatelessWidget {
  const Calender({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();
    return TableCalendar(
      locale: 'ru_RU',
      firstDay: DateTime(2000),
      lastDay: DateTime(2125),
      focusedDay: provider.focusedDay,
      weekendDays: const [],
      selectedDayPredicate: (day) => isSameDay(day, provider.selectedDate),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (selectedDay, focusedDay) {
        HapticFeedback.selectionClick();
        provider.selectedDate = selectedDay;
        // this.focusedDay = selectedDate;
        provider.updateCalendar2(focusedDay, selectedDay);
      },
      onPageChanged: (newMonth) {
        HapticFeedback.selectionClick();
        provider.visibleMonth = newMonth;
        provider.focusedDay = newMonth;
        provider.updateCalendar(newMonth);
      },
      // onDayLongPressed: (selectedDay, focusedDay) {
      //   HapticFeedback.vibrate();
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: const Text('Создать заметку',textAlign: TextAlign.center),
      //       content: const Text('В разработке',textAlign: TextAlign.center),
      //       actions: [
      //         ElevatedButton(
      //           onPressed: () => Navigator.pop(context),
      //           child: Text('ОК',style: Theme.of(context).textTheme.headlineSmall),
      //         ),
      //       ],
      //     ),
      //   );
      // },
      headerVisible: false,

      calendarBuilders: Theme.of(context).calendarStyle2,
      calendarStyle: Theme.of(context).calendarStyle,
      headerStyle: Theme.of(context).headerStyle,
    );
  }
}

class BoxButton extends StatelessWidget {
  const BoxButton({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();
    final now = DateTime.now();
    final isCurrentMonth = provider.focusedDay.month == DateTime.now().month &&
        provider.focusedDay.year == DateTime.now().year;
    if (!isCurrentMonth) {
      return FilledButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            provider.selectedDate = now;
            provider.focusedDay = now;
            provider.updateCalendar(now);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
            // minimumSize: WidgetStateProperty.all<Size>(
            //   const Size(double.infinity, 40),
            // ),
          ),
          child: Text(
            'Вернуться к текущей дате',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        );
      // );
    }
    return const SizedBox(height: 48);
  }
}
