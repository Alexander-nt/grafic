import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateBar extends StatefulWidget implements PreferredSizeWidget {
   const DateBar({super.key});

  @override
  State<DateBar> createState() => _DateBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(60); // высота AppBar
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();
    String focusedDay = toBeginningOfSentenceCase(
      DateFormat.MMMM('ru').format(provider.visibleMonth),
      'ru',
    );
    String focusedYear = DateFormat.y('ru').format(provider.visibleMonth);
    return AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: SizedBox(
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          // verticalDirection: VerticalDirection.up,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  final newMonth = DateTime(provider.focusedDay.year,provider.focusedDay.month - 1, 1);
                  provider.updateCalendar(newMonth);
                });
              },
            ),
            Column(
              children: [
                Text(
                  focusedDay,
                ),
                Text(
                  focusedYear,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() {
                  final newMonth = DateTime(provider.focusedDay.year,provider.focusedDay.month + 1, 1);
                  provider.updateCalendar(newMonth);
                });
              },
            ),
          ],
        ),
      );
  }
}