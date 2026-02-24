import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';

void editBrigadeName(BuildContext context, int index) {
  final provider = context.read<AppDataProvider>();
  final textController =
      TextEditingController(text: provider.currentBrigades[index]);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Изменить название бригады',
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: textController,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Отмена',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          ElevatedButton(
            onPressed: () {
              if (provider.currentSchedule == ScheduleType.dayToNight) {
                provider.brigades[index] = textController.text;
                provider.saveBrigadeNames();
              } else if (provider.currentSchedule == ScheduleType.twoByTwo) {
                provider.brigades2[index] = textController.text;
                provider.saveBrigade2Names();
              }
              Navigator.of(context).pop();
            },
            child: Text('Сохранить',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
        ],
      );
    },
  );
}
