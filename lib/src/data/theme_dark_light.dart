import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class DarkAndLight extends StatefulWidget {
  const DarkAndLight({super.key});
 
  @override
  State<DarkAndLight> createState() => _DarkAndLightState();
}

class _DarkAndLightState extends State<DarkAndLight> {

String themeTitle (BuildContext context){
  final provider = context.read<AppDataProvider>();
    switch (provider.themeMode) {
    case ThemeMode.light:
      return 'Светлая';
    case ThemeMode.dark:
      return 'Тёмная';
    case ThemeMode.system:
      return 'Системная';
    }
}

void themeClick(BuildContext context) {
  final provider = context.read<AppDataProvider>();
  switch (provider.themeMode) {
  case ThemeMode.light:
    provider.themeMode = ThemeMode.dark;
    break;
  case ThemeMode.dark:
    provider.themeMode = ThemeMode.system;
    break;
  case ThemeMode.system:
    provider.themeMode = ThemeMode.light;
    break;
  }
  
}

  @override
  Widget build(BuildContext context) {
  final provider = context.read<AppDataProvider>();
    return ListTile(
      title: const Text('Тема приложения:'),
      subtitle: Text(provider.titleTheme),
      leading: const Icon(Icons.brightness_auto),
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          themeClick(context);
        });
        provider.titleTheme = themeTitle(context);
        provider.saveTheme();   
      },
    );
  }
}