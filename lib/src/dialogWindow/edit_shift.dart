import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';

class DialogEditShift extends StatefulWidget {
  const DialogEditShift({super.key});

  @override
  State<DialogEditShift> createState() => _DialogEditShiftState();
}

class _DialogEditShiftState extends State<DialogEditShift> {

void editShift(BuildContext context) {
  final provider = context.read<AppDataProvider>();

  List<String> brigades = provider.currentBrigades;
  List<String> shifts = provider.currentShifts;
  DateTime dialogDate = provider.selectedDate;
  int currentIndex = 0;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          List<String> todayShifts = provider.getShiftsForDate(dialogDate);
          return AlertDialog(
            title: Text(
              'Изменить смену',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: SizedBox(
              width: double.maxFinite,
              // height: 450,
              // width: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_up, size: 40),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setStateDialog(() {
                          currentIndex = (currentIndex - 1 + shifts.length) %
                              shifts.length;
                          dialogDate =
                              dialogDate.subtract(const Duration(days: 1));
                        });
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // itemCount: brigades.length > 4 ? 4 : brigades.length,
                      itemCount: brigades.length,
                      itemBuilder: (context, index) {
                        final brigade = brigades[index];
                        final shift = todayShifts[index % todayShifts.length];
                        return Card(
                          child: ListTile(
                            title: Text(brigade),
                            subtitle: Text(shift),
                          ),
                        );
                      },
                    ),
                    // ),
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_down, size: 40),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setStateDialog(() {
                          currentIndex = (currentIndex + 1) % shifts.length;
                          dialogDate = dialogDate.add(const Duration(days: 1));
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Отмена',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              ElevatedButton(
                onPressed: () {
                  // сдвиг для смен
                  shifts =
                      List.generate(4, (i) => shifts[(i + currentIndex) % 4]);
                  if (provider.currentSchedule == ScheduleType.dayToNight) {
                    provider.shifts = shifts;
                    provider.saveBrigadeNames();
                  } else if (provider.currentSchedule ==
                      ScheduleType.twoByTwo) {
                    provider.shifts2 = shifts;
                    provider.saveBrigade2Names();
                  }
                  Navigator.of(context).pop();
                  // print(shifts);
                },
                child: Text('Сохранить',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Редактировать смены"),
      leading: const Icon(Icons.edit_calendar),
      onTap: () {
        setState(() {
        Navigator.of(context).pop();
        editShift(context);
        });
      },
    );
  }
}