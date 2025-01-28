import 'package:flutter/material.dart';
import 'package:grafic/theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
       builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling, // Отключение масштабирования
      ),
      child: child!,
    );
  },
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
  List<String> brigades = ['1(2)-я бригада','2(3)-я бригада','3(1)-я бригада','4(4)-я бригада'];
  final List<String> shifts = ['С ночной смены','Выходной','Дневная смена (08:00–20:00)','Ночная смена (20:00–08:00)'];

  DateTime selectedDate = DateTime.now();
  DateTime visibleMonth = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final double dayShiftHours = 11.5;
  final double nightShiftHours = 4.0;
  final double fromNightShiftHours = 7.5;

  @override
  void initState() {
    super.initState();
    _loadBrigadeNames(); // Загрузка сохраненных названий при запуске
  }

  // Загрузка названий бригад из SharedPreferences
  Future<void> _loadBrigadeNames() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brigades = prefs.getStringList('brigades') ?? brigades;
    });
  }

  // Сохранение названий бригад в SharedPreferences
  Future<void> _saveBrigadeNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('brigades', brigades);
  }

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
          // elevation: 90,
          title: Text(
            brigade,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
            ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\nЗа $monthName месяц:\n',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                'Дневные смены: ${stats['dayShifts']}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Divider(),
              Text(
                'Ночные смены: ${stats['nightShifts']}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Divider(),
              Text(
                'Рабочие часы за месяц: ${stats['hours']} ч',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Divider()
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Закрыть',
                style: Theme.of(context).textTheme.headlineSmall
              ),
            ),
          ],
        );
      },
    );
  }

  void editBrigadeName(BuildContext context, int index) {
    TextEditingController textController = TextEditingController(text: brigades[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить название бригады'),
          content: TextField(
            controller: textController,
            style: Theme.of(context).textTheme.displayLarge,
            // decoration: const InputDecoration(
            //   labelText: 'Название бригады',
            // ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена',
              style: Theme.of(context).textTheme.headlineSmall
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  brigades[index] = textController.text;
                });
                _saveBrigadeNames();
                Navigator.of(context).pop();
              },
              child: Text('Сохранить',
              style: Theme.of(context).textTheme.headlineSmall
              ),
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
      appBar: AppBar(title: Text(widget.title),
      // actions: [
      //   if (focusedDay.year != DateTime.now().year || focusedDay.month != DateTime.now().month)
      //   IconButton(
      //     color: Colors.green,
      //     icon: const Icon(Icons.sync, size: 32,),
      //     onPressed: () {
      //       setState(() {
      //         focusedDay = DateTime.now(); // Возврат к текущему дню
      //         // visibleMonth = DateTime.now(); // Возврат к текущему дню
      //         selectedDate = DateTime.now(); // Возврат к текущему дню
      //       });
      //     },
      //   ),
      // ],
    ),
      body: Column(
        children: [
          //Календарь
          TableCalendar(
            locale: 'ru_RU',
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            focusedDay: focusedDay,
            weekendDays: const [],
            selectedDayPredicate: (day) => isSameDay(day, selectedDate),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay; // Обновляем выбранную дату
                this.focusedDay = selectedDate;
              });
            },
            onPageChanged: (newMonth) {
              // Обновляем видимый месяц при перелистывании
              setState(() {
                visibleMonth = newMonth; // Обновляем только видимый месяц
                focusedDay = newMonth; // Также обновляем сосредоточенный день
              });
            },
            calendarStyle: Theme.of(context).calendarStyle, // Используем стили темы
            headerStyle: Theme.of(context).headerStyle, // Используем стили темы
          ),
          if (focusedDay.year != DateTime.now().year || focusedDay.month != DateTime.now().month)
          FilledButton(
            onPressed: () {
              setState(() {
                selectedDate = DateTime.now(); // Возвращаем выбранную дату на сегодня
                focusedDay = DateTime.now(); // Возвращаем выбранную дату на сегодня
              });
            },
            style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.green),),
            // icon: const Icon(Icons.sync, size: 32,),
            child: Text(
              'Вернуться к текущему месяцу',
              style: Theme.of(context).textTheme.displaySmall,
              ),
          ),
          if (focusedDay.month == DateTime.now().month)
          if ( focusedDay.year == DateTime.now().year)
          const SizedBox(height: 48),
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
                    // trailing: const Icon(Icons.touch_app, size: 35,),
                    // leading: const Icon(Icons.radio_button_checked, color: Colors.red),
                    trailing: IconButton(
                      onPressed: () {
                        showShiftDetails(context, brigade, stats);
                      },
                      icon: Icon(Icons.info, size: 40, color: Colors.blueAccent[100],), // Ваша иконка
                      tooltip: 'Кол-во смен и часов в выбранный месяц'
                    ), // Всплывающая подсказка (опционально)
                    onLongPress: () {
                      editBrigadeName(context, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
