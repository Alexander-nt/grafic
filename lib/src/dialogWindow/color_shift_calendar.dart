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
  Colors.grey,
  Colors.brown,
  Colors.transparent,


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

class DialogColorShifts extends StatefulWidget {
  const DialogColorShifts({super.key});

  @override
  State<DialogColorShifts> createState() => _DialogState();
}

class _DialogState extends State<DialogColorShifts> {

void _showShiftDialog(BuildContext context) {
  final provider = context.read<AppDataProvider>();

  List<Color> shiftsColors = List.generate(provider.currentShifts.length, (index) => provider.currentShiftsColors[index % provider.currentShiftsColors.length]);
  List<String> activeBrigades = provider.currentBrigades;
  List<String> activeShifts = provider.currentShifts;
  int brigadeIndex = provider.currentBrigadeIndex;
  bool shiftsColrlight = provider.shiftsColrlight;

  showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
      builder: (context, setStateDialog) {
      return AlertDialog(
        title: Container(
          height: 40,
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
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
                   if (shiftsColrlight == true && provider.listIndexBrigade == false)
                   const Text(
                    'Выбери бригаду для отслеживания:',
                    textAlign: TextAlign.center,
                  ),
                   if (shiftsColrlight == true && provider.listIndexBrigade == false)
                   ListView.builder(
                    physics:const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // itemCount: activeBrigades.length > 4 ? 4 : activeBrigades.length,
                    itemCount: activeBrigades.length,
                    itemBuilder: (context, index) {
                      final brigade = activeBrigades[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Builder(
                          builder: (BuildContext context) {
                            return ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              splashColor: Colors.transparent,
                              title: Text(brigade),
                              trailing: Icon(
                                brigadeIndex == index ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                              ),
                              onTap: () {
                                HapticFeedback.vibrate();
                                setStateDialog(() {
                                  brigadeIndex = index;
                                });
                              },
                            );
                          }
                        )
                      );
                    },
                  ),
                  if (shiftsColrlight == true && provider.listIndexBrigade == false)
                   const SizedBox(height: 30,),
                  if (shiftsColrlight == true)
                  const Text(
                    'Выбери цвета отображения смен:',
                    textAlign: TextAlign.center,
                    // style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                   if (shiftsColrlight == true)
                   ListView.builder(
                        physics:const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: activeShifts.length,
                        itemBuilder: (context, index) {
                          final shift = activeShifts[index];
                          return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Builder(
                            builder: (BuildContext context) {
                              return ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                splashColor: Colors.transparent,
                                title: Text(shift),
                                trailing: Material(
                                  color: Colors.transparent,
                                  shape: const CircleBorder(),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: shiftsColors[index],
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black26),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  HapticFeedback.vibrate();
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return ListView(
                                        children: shiftColors.map((color) {
                                          return ListTile(
                                            leading: CircleAvatar(backgroundColor: color),
                                            title: Text(colorToName(color)),
                                            onTap: () {
                                              setStateDialog(() {
                                                shiftsColors[index] = color;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          )
                          );
                        },
                      ),
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
                          provider.brigadeIndex = brigadeIndex;         
                    } else if (provider.currentSchedule == ScheduleType.twoByTwo) {
                          provider.shiftColors2 = shiftsColors;     
                          provider.brigadeIndex2 = brigadeIndex;                         
                    }
                    provider.shiftsColrlight = shiftsColrlight;
                    provider.saveBrigadeindex();
                    provider.saveBoolIndex();
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
      title: const Text("Выбрать цвет смены"),
      leading: const Icon(Icons.edit_calendar),
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).pop();
        setState(() {
        _showShiftDialog(context);
        });
        
      },
    );
  }
}
