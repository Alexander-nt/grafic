import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

List<Color> shiftColors = [
  Colors.orangeAccent,
  Colors.blueAccent,
  Colors.green,
  Colors.redAccent,
  Colors.purpleAccent,
  Colors.lightGreenAccent,
  Colors.yellowAccent,
  Colors.black,
  Colors.white,
  Colors.transparent,
  Colors.grey,
  Colors.brown,

];
// отображения имени цвета
String colorToName(Color color) {
  if (color == Colors.orangeAccent) return 'Оранжевый';
  if (color == Colors.blueAccent) return 'Синий';
  if (color == Colors.green) return 'Зелёный';
  if (color == Colors.redAccent) return 'Красный';
  if (color == Colors.purpleAccent) return 'Фиолетовый';
  if (color == Colors.lightGreenAccent) return 'Светло зелёный';
  if (color == Colors.yellowAccent) return 'Желтый';
  if (color == Colors.grey) return 'Серый';
  if (color == Colors.brown) return 'Коричневый';
  if (color == Colors.black) return 'Черный';
  if (color == Colors.white) return 'Белый';
  if (color == Colors.transparent) return 'Бесцветный';
  return 'Цвет';
}

class DialogDisplayShifts extends StatefulWidget {
  const DialogDisplayShifts({super.key});

  @override
  State<DialogDisplayShifts> createState() => _DialogState();
}

class _DialogState extends State<DialogDisplayShifts> {

void _showShiftDialog(BuildContext context) {
  final provider = context.read<AppDataProvider>();

  List<Color> shiftsColors = List.generate(provider.currentShifts.length, (index) => provider.currentShiftsColors[index % provider.currentShiftsColors.length]);
  List<String> activeBrigades = provider.currentBrigades;
  List<String> activeShifts = provider.currentShifts;
  int br5 = provider.currentBrigadeIndex;
  bool shiftsColrlight = provider.shiftsColrlight;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
      builder: (context, setStateDialog) {
      return AlertDialog(
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Показать цвет смены',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
                Switch(
                  value: shiftsColrlight,
                  onChanged: (bool value) {
                    HapticFeedback.vibrate();
                    setStateDialog(() {
                      shiftsColrlight = value;
                    });
                  },
                ),
            ],
            ),
        ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   if (shiftsColrlight == true)
                   const Text(
                    'Выбери бригаду для отслеживания:',
                    textAlign: TextAlign.center,
                  ),
                   if (shiftsColrlight == true)
                   Card(
                     child: ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // itemCount: activeBrigades.length > 4 ? 4 : activeBrigades.length,
                        itemCount: activeBrigades.length,
                        itemBuilder: (context, index) {
                          final brigade = activeBrigades[index];
                            return ListTile(
                              title: Text(brigade),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Radio<int>(
                                    value: index,
                                    groupValue: br5,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        HapticFeedback.vibrate();
                                        setStateDialog(() {
                                          br5 = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          // );
                        },
                      ),
                  ),
                  if (shiftsColrlight == true)
                   const SizedBox(height: 30,),
                  if (shiftsColrlight == true)
                  const Text(
                    'Выбери цвета отображения смен:',
                    textAlign: TextAlign.center,
                    // style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                   if (shiftsColrlight == true)
                    Card(
                      child: ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // itemCount: activeShifts.length > 4 ? 4 : activeShifts.length,
                        itemCount: activeShifts.length,
                        itemBuilder: (context, index) {
                          final shift = activeShifts[index];
                            return ListTile(
                              title: Text(shift),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PopupMenuButton<Color>(
                                    icon: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: shiftsColors[index],
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black26),
                                      ),
                                    ),
                                    onSelected: (color) {
                                      HapticFeedback.vibrate();
                                      setStateDialog(() {
                                        shiftsColors[index] = color;
                                        // print(shiftsColors);
                                      });
                                    },
                                    itemBuilder: (context) => shiftColors
                                        .map((color) => PopupMenuItem<Color>(
                                              value: color,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.black26),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(colorToName(color)),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            );
                          // );
                        },
                      ),
                    ),
                  // ),
                  ],
                ),
              ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Отмена', style: Theme.of(context).textTheme.headlineSmall),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (provider.currentSchedule == ScheduleType.dayToNight) {
                          provider.shiftColors = shiftsColors;   
                          provider.brigadeIndex = br5;         
                    } else if (provider.currentSchedule == ScheduleType.twoByTwo) {
                          provider.shiftColors2 = shiftsColors;     
                          provider.brigadeIndex2 = br5;                         
                    }
                    provider.shiftsColrlight = shiftsColrlight;
                    provider.saveBrigadeindex();
                    provider.saveshiftsColorlight();
                    Navigator.of(context).pop();
                  },
                  child: Text('Сохранить', style: Theme.of(context).textTheme.headlineSmall),
                ),
            ],
          );
        }
      );
    },
  );
}

  @override
  Widget build(BuildContext context,) {
    return ListTile(
      title: const Text("Изменить цвет смены"),
      leading: const Icon(Icons.edit_calendar),
      onTap: () {
        setState(() {
        Navigator.of(context).pop();
        _showShiftDialog(context);
        });
      },
    );
  }
}
