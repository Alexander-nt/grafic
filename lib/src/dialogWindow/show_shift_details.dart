import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';

void showShiftDetails(
    BuildContext context, String brigade, Map<String, dynamic> stats) {
  final provider = context.read<AppDataProvider>();
  showDialog(
    context: context,
    builder: (context) {
      String monthName = DateFormat.MMMM('ru_RU').format(provider.selectedDate);
      if (provider.currentSchedule == ScheduleType.twoByTwo) {
        return AlertDialog(
          title: Text(
            brigade,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\nЗа $monthName месяц:\n',
                    style: Theme.of(context).textTheme.displayMedium),
                Text('Дневные смены: ${stats['dayShifts']}',
                    style: Theme.of(context).textTheme.displaySmall),
                const Divider(),
                Text('Выходные: ${stats['weekend']}',
                    style: Theme.of(context).textTheme.displaySmall),
                const Divider(),
                Text('Рабочие часы за месяц: ${stats['hours']} ч',
                    style: Theme.of(context).textTheme.displaySmall),
                const Divider()
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Закрыть',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ],
        );
      }
      return AlertDialog(
        title: Text(
          brigade,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\nЗа $monthName месяц:\n',
                style: Theme.of(context).textTheme.displayMedium),
            Text('Дневные смены: ${stats['dayShifts']}',
                style: Theme.of(context).textTheme.displaySmall),
            const Divider(),
            Text('Ночные смены: ${stats['nightShifts']}',
                style: Theme.of(context).textTheme.displaySmall),
            const Divider(),
            Text('Рабочие часы за месяц: ${stats['hours']} ч',
                style: Theme.of(context).textTheme.displaySmall),
            const Divider()
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Закрыть',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
        ],
      );
    },
  );
}
