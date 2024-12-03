import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ShiftScheduleScreen(),
    );
  }
}

class ShiftScheduleScreen extends StatefulWidget {
  const ShiftScheduleScreen({super.key});

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
        return AlertDialog(
          title: Text(brigade),
          content: Text(
            'Дневные смены: ${stats['dayShifts']}\n'
            'Ночные смены: ${stats['nightShifts']}\n'
            // 'С ночной смены: ${stats['fromNightShifts']}\n'
            'Рабочие часы за месяц: ${stats['hours']} ч',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35.0),
            child: Text(
              'График смен',
              style: GoogleFonts.notoSerif(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 48,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TableCalendar(
            locale: 'ru_RU',
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: selectedDate,
            weekendDays: const [],
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              // defaultTextStyle: TextStyle(
              //   color: Colors.white,
              // ),
              weekendDecoration: BoxDecoration(
                color: Colors.white10,
                shape: BoxShape.circle,
              ),
              // weekendTextStyle: TextStyle(
              //   color: Colors.white,
              // ),
              // outsideDecoration: BoxDecoration(
              //   color: Colors.black38,
              //   shape: BoxShape.circle,
              // ),
              // outsideTextStyle: TextStyle(
              //   color: Colors.grey,
              // ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
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
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                        color: Colors.blueGrey,
                      ),
                    ),
                    subtitle: Text(
                      todayShifts[index],
                      style: GoogleFonts.roboto(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 20,
                      ),
                    ),
                    onLongPress: () {
                      showShiftDetails(context, brigade, stats);
                    },
                  ),
                );
              },
            ),
          ),
          Text(
            't.me/@Alexander_nt',
            style: GoogleFonts.notoSerif(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 7,
                // fontWeight: FontWeight.w500,
                // fontStyle: FontStyle.italic,
                // color: Colors.red
              ),
          ),
        ],
      ),
    );
  }
}
