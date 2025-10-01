import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:flutter/services.dart';
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
    const dividerDrawer = Divider(height: 10, indent: 20, endIndent: 20);
    int selectedIndex(){
      int selectedIndex = 0;
      switch (provider.currentSchedule){
        case ScheduleType.dayToNight:
        selectedIndex = 0;
        case ScheduleType.twoByTwo:
        selectedIndex = 1;
      }
      return selectedIndex;
    }
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NavigationDrawer(
                selectedIndex: selectedIndex(),
                onDestinationSelected: (index) {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                  switch (index) {
                    case 0:
                      provider.currentSchedule = ScheduleType.dayToNight;
                      provider.saveScheduleType(ScheduleType.dayToNight);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("Напоминания выбраны")),
                      // );
                      break;
                    case 1:
                      provider.currentSchedule = ScheduleType.twoByTwo;
                      provider.saveScheduleType(ScheduleType.twoByTwo);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text("Напоминания выбраны")),
                      // );
                      break;
                  }
                },
                children: [
                  ListTile(
                    title: Text('График смен', style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  dividerDrawer,
                  const ListTile(
                    title:Text("Выбери график:", style: TextStyle(fontSize: 15))),
                  const NavigationDrawerDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month, color: Colors.green),
                    label: Text("сутра в ночь"),
                  ),
                  const NavigationDrawerDestination(
                    icon: Icon(Icons.calendar_month_outlined),
                    selectedIcon: Icon(Icons.calendar_month, color: Colors.green),
                    label: Text("два через два"),
                  ),
                  dividerDrawer,
                  const ListTile(
                    title:Text("Настройки календаря:", style: TextStyle(fontSize: 15))),
                  const DialogEditShift(),
                  const DialogColorShifts(),
                  const DialogIndexBrigade(),
                ]
              )
            ),
            dividerDrawer,
            const DarkAndLight(),
          ]
        ),
      ),
    );
  }
}