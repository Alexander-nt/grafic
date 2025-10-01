import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class DialogIndexBrigade extends StatefulWidget {
  const DialogIndexBrigade({super.key});

  @override
  State<DialogIndexBrigade> createState() => _IndexBrigadeState();
}

class _IndexBrigadeState extends State<DialogIndexBrigade> {
  
  void _showBrigadeIndex(BuildContext context) {
  final provider = context.read<AppDataProvider>();

  List<String> activeBrigades = provider.currentBrigades;
  int listBrigadeIndex = provider.currentListBrigadeIndex;
  bool listIndexBrigade = provider.listIndexBrigade;
  String title (){
    String title = 'Показыть одну бригаду';
      switch (listIndexBrigade) {
      case true:
        title = 'Показыть одну бригаду';
        case false:
          title = 'Показыть все бригады';
      }
      return title;
  }
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
              Expanded(
                child: Text(title(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
                Switch(
                  value: listIndexBrigade,
                  onChanged: (bool value) {
                    HapticFeedback.vibrate();
                    setStateDialog(() {
                      listIndexBrigade = value;
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
                   if (listIndexBrigade == true)
                   const Text(
                    'Выбери какую бригаду показывать:',
                    textAlign: TextAlign.center,
                  ),
                   if (listIndexBrigade == true)
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
                                    groupValue: listBrigadeIndex,
                                    onChanged: (int? value) {
                                      if (value != null) {
                                        HapticFeedback.vibrate();
                                        setStateDialog(() {
                                          listBrigadeIndex = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                        },
                      ),
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
                          provider.listBrigadeIndex = listBrigadeIndex;
                          provider.brigadeIndex = listBrigadeIndex;
                    } else if (provider.currentSchedule == ScheduleType.twoByTwo) {
                          provider.listBrigadeIndex2 = listBrigadeIndex;
                          provider.brigadeIndex2 = listBrigadeIndex;                              
                    }
                    provider.listIndexBrigade = listIndexBrigade;
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
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Выбор списка бригад"),
      leading: const Icon(Icons.list),
      onTap: () {
        setState(() {
        Navigator.of(context).pop();
        _showBrigadeIndex(context);
        });
      },
    );
  }
}