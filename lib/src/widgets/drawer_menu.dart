import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();

    return Drawer(
      elevation: double.maxFinite,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                    title: Text('График смен',
                        style: Theme.of(context).textTheme.headlineLarge)),
                const Divider(height: 10, indent: 20, endIndent: 20),
                Column(
                  children: [
                    const ListTile(
                      title:
                          Text("Выбери график", style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      title: const Text("сутра в ночь"),
                      selected:
                          provider.currentSchedule == ScheduleType.dayToNight,
                      selectedTileColor: Colors.transparent,
                      leading: const Icon(Icons.calendar_month),
                      onTap: () {
                        setState(() {
                          provider.currentSchedule = ScheduleType.dayToNight;
                        });
                        provider.saveScheduleType(ScheduleType.dayToNight);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text("два через два"),
                      selected:
                          provider.currentSchedule == ScheduleType.twoByTwo,
                      selectedTileColor: Colors.transparent,
                      leading: const Icon(Icons.calendar_month),
                      onTap: () {
                        setState(() {
                          provider.currentSchedule = ScheduleType.twoByTwo;
                        });
                        provider.saveScheduleType(ScheduleType.twoByTwo);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const Divider(height: 10, indent: 20, endIndent: 20),
                ListTile(
                  title: const Text("Редактировать смены"),
                  leading: const Icon(Icons.edit_calendar),
                  onTap: () {
                    Navigator.pop(context);
                    return editShiftsName(context);
                  },
                ),
                const DialogDisplayShifts(),
              ],
            ),
          ),
          // const Divider(height: 10,  indent: 20, endIndent: 20),
          // ListTile(
          //   title: const Text("О приложении"),
          //   leading: const Icon(Icons.info),
          //   onTap: () {
          //     Navigator.pop(context);
          //     info(context);
          //   },
          // ),
        ],
      ),
    );
  }
}
