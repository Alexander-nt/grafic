import 'package:flutter/material.dart';
import 'package:grafic/import.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
      title: 'График смен',
      theme: customTheme(Brightness.light),
      darkTheme: customTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const ShiftScheduleScreen(title: 'График смен'),
    );
  }
}

class ShiftScheduleScreen extends StatefulWidget {
  const ShiftScheduleScreen({super.key, required this.title});
  final String title;

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
    final provider = context.watch<AppDataProvider>();
    String focusedDay = toBeginningOfSentenceCase(
      DateFormat.MMMM('ru').format(provider.visibleMonth),
      'ru',
    );
    String focusedYear = DateFormat.y('ru').format(provider.visibleMonth);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: SizedBox(
          child: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          // verticalDirection: VerticalDirection.up,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  final newMonth = DateTime(provider.focusedDay.year,
                      provider.focusedDay.month - 1, 1);
                  provider.updateCalendar(newMonth);
                });
              },
            ),
            Column(
              children: [
                Text(
                  focusedDay,
                ),
                Text(
                  focusedYear,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  final newMonth = DateTime(provider.focusedDay.year,
                      provider.focusedDay.month + 1, 1);
                  provider.updateCalendar(newMonth);
                });
              },
            ),
          ],
        ),
      ),
      drawer: const MenuDrawer(),
      body: const Column(
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
          //   Center(
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       await setAlarm(6, 10);
          //     },
          //     child: const Text("Поставить будильник на 06:10"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
