import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppDataProvider(),
      child: const ShiftSchedulerApp(),
    ),
  );
  // runApp(
  // MultiProvider(
  //   providers: [
  //     ChangeNotifierProvider(create: (_) => AppDataProvider()),
  //     ChangeNotifierProvider(create: (_) => DataProvider()),
  //   ],
    // child: const ShiftSchedulerApp(),
  // ),
// );
}

class ShiftSchedulerApp extends StatelessWidget {
  const ShiftSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
  final provider = context.watch<AppDataProvider>();
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
      theme: customTheme(Brightness.light),
      darkTheme: customTheme(Brightness.dark),
      themeMode: provider.currentThemeMode,
      home: const ShiftScheduleScreen(),
    );
  }
}

class ShiftScheduleScreen extends StatefulWidget {
  const ShiftScheduleScreen({super.key});

  @override
  ShiftScheduleScreenState createState() => ShiftScheduleScreenState();
}

class ShiftScheduleScreenState extends State<ShiftScheduleScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppDataProvider>().loadScheduleType();
    context.read<AppDataProvider>().loadBrigadeNames();
    context.read<AppDataProvider>().loadShiftColors();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DateBar(),
      drawer: MenuDrawer(),
      body: Column(
        children: [
          Divider(
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          Calender(),
          BoxButton(),
          BrigadesList(),
        ],
      ),
    );
  }
}
