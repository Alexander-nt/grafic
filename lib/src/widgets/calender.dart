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
      lastDay: DateTime(2050),
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
      headerVisible: false,

      calendarBuilders: Theme.of(context).calendarStyle2,
      calendarStyle: Theme.of(context).calendarStyle,
      // calendarStyle: Theme.of(context).calendarStyle(shiftColor, shiftsColrlight),
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
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: FilledButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            provider.selectedDate = now;
            provider.focusedDay = now;
            provider.updateCalendar(now);
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
          ),
          child: Text(
            'Вернуться к текущей дате',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      );
    }
    return const SizedBox(height: 54);
  }
}
