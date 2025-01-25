import 'package:flutter/material.dart';
import 'package:grafic/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);

  runApp(const ShiftSchedulerApp());
}

class ShiftSchedulerApp extends StatelessWidget {
  const ShiftSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'График смен',
      theme: customTheme(Brightness.light), // Подключение светлой темы
      darkTheme: customTheme(Brightness.dark), // Темная тема
      // darkTheme: darkTheme, // Подключение темной темы
      themeMode: ThemeMode.system, // Выбор темы в зависимости от настроек системы
      home: const ShiftScheduleScreen(title: 'График смен'),
    );
  }
}

class ShiftScheduleScreen extends StatefulWidget {
  const ShiftScheduleScreen({super.key, required this.title});

  final String title;

  @override
  _ShiftScheduleScreenState createState() => _ShiftScheduleScreenState();
}

class _ShiftScheduleScreenState extends State<ShiftScheduleScreen> {
  final List<String> brigades = ['1(2)-я бригада','2(3)-я бригада','3(1)-я бригада','4(4)-я бригада'];
  final List<String> shifts = ['С ночной смены','Выходной','Дневная смена (08:00–20:00)','Ночная смена (20:00–08:00)'];

  DateTime selectedDate = DateTime.now();

  final double dayShiftHours = 11.5;
  final double nightShiftHours = 4.0;
  final double fromNightShiftHours = 7.5;

  List<String> getShiftsForDate(DateTime date) {
    int dayIndex = date.difference(DateTime(2024, 1, 2)).inDays % 4;

    List<String> calculatedShifts =
        List.generate(4, (i) => shifts[(i + dayIndex) % 4]);

    String temp = calculatedShifts[0];
    calculatedShifts[0] = calculatedShifts[2];
    calculatedShifts[2] = temp;

    return calculatedShifts;
  }

  Map<String, Map<String, dynamic>> calculateMonthlyStats(DateTime month) {
    Map<String, Map<String, dynamic>> monthlyStats = {
      for (var brigade in brigades)
        brigade: {
          'hours': 0,
          'dayShifts': 0,
          'nightShifts': 0,
          'fromNightShifts': 0
        },
    };

    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(month.year, month.month, day);
      List<String> dailyShifts = getShiftsForDate(date);

      for (int i = 0; i < brigades.length; i++) {
        String shift = dailyShifts[i];

        if (shift == 'Дневная смена (08:00–20:00)') {
          monthlyStats[brigades[i]]!['dayShifts'] =
              monthlyStats[brigades[i]]!['dayShifts']! + 1;
          monthlyStats[brigades[i]]!['hours'] =
              monthlyStats[brigades[i]]!['hours']! + dayShiftHours;
        } else if (shift == 'Ночная смена (20:00–08:00)') {
          monthlyStats[brigades[i]]!['nightShifts'] =
              monthlyStats[brigades[i]]!['nightShifts']! + 1;
          monthlyStats[brigades[i]]!['hours'] =
              monthlyStats[brigades[i]]!['hours']! + nightShiftHours;
        } else if (shift == 'С ночной смены') {
          monthlyStats[brigades[i]]!['fromNightShifts'] =
              monthlyStats[brigades[i]]!['fromNightShifts']! + 1;
          monthlyStats[brigades[i]]!['hours'] =
              monthlyStats[brigades[i]]!['hours']! + fromNightShiftHours;
        }
      }
    }
    return monthlyStats;
  }

  void showShiftDetails(BuildContext context, String brigade, Map<String, dynamic> stats) {
    showDialog(
      context: context,
      builder: (context) {
        String monthName = DateFormat.MMMM('ru_RU').format(selectedDate);
        return AlertDialog(
          title: Text(
            'За $monthName месяц:''\n''$brigade',
            style: Theme.of(context).textTheme.displayLarge,
            ),
          content: Text(
            'Дневные смены: ${stats['dayShifts']}\n\n'
            'Ночные смены: ${stats['nightShifts']}\n\n'
            // 'С ночной смены: ${stats['fromNightShifts']}\n'
            'Рабочие часы за месяц: ${stats['hours']} ч',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          // actions: [
            // TextButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: const Text('Закрыть'),
            // ),
          // ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> todayShifts = getShiftsForDate(selectedDate);

    Map<String, Map<String, dynamic>> monthlyStats =
        calculateMonthlyStats(selectedDate);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          //Календарь
          TableCalendar(
            locale: 'ru_RU',
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            focusedDay: selectedDate,
            weekendDays: const [],
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
            },
            calendarStyle: Theme.of(context).calendarStyle, // Используем стили темы
            headerStyle: Theme.of(context).headerStyle, // Используем стили темы
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: brigades.length,
              itemBuilder: (context, index) {
                final brigade = brigades[index];
                final stats = monthlyStats[brigade]!;

                return Card(
                  child: ListTile(
                    title: Text(
                      brigade,
                        style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      todayShifts[index],
                        style: Theme.of(context).textTheme.titleMedium,
                    ),
                    splashColor:Colors.blueAccent,
                    trailing: const Icon(Icons.touch_app, size: 35,),
                    // leading: const Icon(Icons.radio_button_checked, color: Colors.red),
                    onLongPress: () {
                      showShiftDetails(context, brigade, stats);
                    },
                  ),
                );
              },
            ),
          ),
          // Text(
          //   't.me/@Alexander_nt',
          //   style: GoogleFonts.notoSerif(
          //       textStyle: Theme.of(context).textTheme.displayLarge,
          //       fontSize: 7,
                // fontWeight: FontWeight.w500,
                // fontStyle: FontStyle.italic,
                // color: Colors.red
          //     ),
          // ),
        ],
      ),
    );
  }
}
