import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ScheduleType {
  dayToNight,
  twoByTwo,
}

class AppDataProvider extends ChangeNotifier {
  List<String> brigades = [
    '1-я бригада',
    '2-я бригада',
    '3-я бригада',
    '4-я бригада'
  ];
  List<String> shifts = [
    'Дневная смена (08:00–20:00)',
    'Ночная смена (20:00–08:00)',
    'С ночной смены',
    'Выходной'
  ];

  List<String> brigades2 = ['1-я бригада', '2-я бригада'];
  List<String> shifts2 = [
    '1-я смена',
    '2-я смена',
    '1-й выходной',
    '2-й выходной',
  ];

  int brigadeIndex = 3;
  int brigadeIndex2 = 0;
  bool shiftsColrlight = true;

  DateTime selectedDate = DateTime.now();
  DateTime visibleMonth = DateTime.now();
  DateTime focusedDay = DateTime.now();

  ScheduleType currentSchedule = ScheduleType.dayToNight;
  List<String> get currentBrigades =>
      currentSchedule == ScheduleType.dayToNight ? brigades : brigades2;
  List<String> get currentShifts =>
      currentSchedule == ScheduleType.dayToNight ? shifts : shifts2;
  int get currentBrigadeIndex =>
      currentSchedule == ScheduleType.dayToNight ? brigadeIndex : brigadeIndex2;
  List<Color> get currentShiftsColors =>
      currentSchedule == ScheduleType.dayToNight ? shiftColors : shiftColors2;

  Color colorsShift(DateTime day, focusedDay) {
    final shifts = getShiftsForDate(day);
    final shift = shifts[brigadeIndex % shifts.length];
    final shift2 = shifts[brigadeIndex2 % shifts.length];
    Color bgColor = Colors.white;
    if (currentSchedule == ScheduleType.dayToNight) {
      if (shift == 'Дневная смена (08:00–20:00)') {
        bgColor = shiftColors[0]; // Дневная
      } else if (shift == 'Ночная смена (20:00–08:00)') {
        bgColor = shiftColors[1]; // Ночная
      } else if (shift == 'С ночной смены') {
        bgColor = shiftColors[2]; // После ночной
      } else if (shift == 'Выходной') {
        bgColor = shiftColors[3]; // Выходной
      }
    } else if (currentSchedule == ScheduleType.twoByTwo) {
      if (shift2 == '1-я смена') {
        bgColor = shiftColors2[0]; // 1-я и 2-я смена
      } else if (shift2 == '2-я смена') {
        bgColor = shiftColors2[1]; // Выходной
      } else if (shift2 == '1-й выходной') {
        bgColor = shiftColors2[2]; // Выходной
      } else if (shift2 == '2-й выходной') {
        bgColor = shiftColors2[3]; // Выходной
      }
    }
    return bgColor;
  }

  List<String> getShiftsForDate(date) {
    if (currentSchedule == ScheduleType.dayToNight) {
      int dayIndex = date.difference(DateTime(2024, 1, 4)).inDays % 4;
      List<String> calculatedShifts =
          List.generate(4, (i) => shifts[(i + dayIndex) % 4]);
      String temp = calculatedShifts[0];
      calculatedShifts[0] = calculatedShifts[2];
      calculatedShifts[2] = temp;
      return calculatedShifts;
    } else if (currentSchedule == ScheduleType.twoByTwo) {
      int dayIndex = date.difference(DateTime(2024, 1, 1)).inDays % 4;
      List<String> calculatedShifts =
          List.generate(4, (i) => shifts2[(i + dayIndex) % 4]);
      String temp = calculatedShifts[2];
      calculatedShifts[1] = temp;
      return calculatedShifts;
    } else {
      return [];
    }
  }

  List<Color> shiftColors = [
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent
  ];

  List<Color> shiftColors2 = [
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.green,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.lightGreenAccent,
    Colors.yellowAccent
  ];

  void editBrigade(int index, String newName) {
    brigades[index] = newName;
    notifyListeners(); // 👉 уведомляем UI
  }

  void updateCalendar(DateTime newMonth) {
    visibleMonth = newMonth;
    focusedDay = newMonth;
    notifyListeners(); // 👉 уведомляем UI
  }

  void updateCalendar2(focusfocusedDay, selectedDayedDay) {
    selectedDate = selectedDate;
    focusedDay = selectedDate;
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> loadBrigadeNames() async {
    final prefs = await SharedPreferences.getInstance();
    brigades = prefs.getStringList('brigades') ?? brigades;
    shifts = prefs.getStringList('shifts') ?? shifts;
    brigades2 = prefs.getStringList('brigades2') ?? brigades2;
    shifts2 = prefs.getStringList('shifts2') ?? shifts2;
    brigadeIndex = prefs.getInt('brigadeIndex') ?? brigadeIndex;
    brigadeIndex2 = prefs.getInt('brigadeIndex2') ?? brigadeIndex2;
    shiftsColrlight = prefs.getBool('shiftsColrlight') ?? shiftsColrlight;
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> loadShiftColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorStrings = prefs.getStringList('shiftColors');
    if (colorStrings != null) {
      shiftColors = colorStrings.map((s) => Color(int.parse(s))).toList();
    }
    final colorStrings2 = prefs.getStringList('shiftColors2');
    if (colorStrings2 != null) {
      shiftColors2 = colorStrings2.map((s) => Color(int.parse(s))).toList();
    }
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> loadShiftsColrlight() async {
    final prefs = await SharedPreferences.getInstance();
    shiftsColrlight = prefs.getBool('shiftsColrlight') ?? shiftsColrlight;
    // notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> saveBrigadeNames() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('brigades', brigades);
    await prefs.setStringList('shifts', shifts);
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> saveBrigade2Names() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('brigades2', brigades2);
    await prefs.setStringList('shifts2', shifts2);
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> saveScheduleType(ScheduleType schedule) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scheduleType', schedule.index);
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> saveBrigadeindex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('brigadeIndex', brigadeIndex);
    await prefs.setInt('brigadeIndex2', brigadeIndex2);
    final colorStrings = shiftColors.map((c) => c.value.toString()).toList();
    await prefs.setStringList('shiftColors', colorStrings);
    final colorStrings2 = shiftColors2.map((c) => c.value.toString()).toList();
    await prefs.setStringList('shiftColors2', colorStrings2);
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> saveshiftsColorlight() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shiftsColrlight', shiftsColrlight);
    notifyListeners(); // 👉 уведомляем UI
  }

  Future<void> loadScheduleType() async {
    final prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt('scheduleType');
    if (index != null) {
      currentSchedule = ScheduleType.values[index];
      notifyListeners(); // 👉 уведомляем UI
    }
  }
}
