import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grafic/import.dart';
import 'package:provider/provider.dart';

class BrigadesList extends StatefulWidget {
  const BrigadesList({super.key});

  @override
  State<BrigadesList> createState() => _BrigadesListState();
}
    const double dayShiftHours = 11.5;
    const double nightShiftHours = 4.0;
    const double fromNightShiftHours = 7.5;
    
class _BrigadesListState extends State<BrigadesList> {
  @override
  Widget build(BuildContext context) {


    Map<String, Map<String, dynamic>> calculateMonthlyStats(
        DateTime month, List<String> brigadeList) {
      Map<String, Map<String, dynamic>> monthlyStats = {
        for (var brigade in brigadeList)
          brigade: {
            'hours': 0.0,
            'dayShifts': 0,
            'nightShifts': 0,
            'fromNightShifts': 0,
            'weekend': 0,
          },
      };

      int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

      for (int day = 1; day <= daysInMonth; day++) {
        DateTime date = DateTime(month.year, month.month, day);
        final provider = context.read<AppDataProvider>();
        final getShiftsForDate = provider.getShiftsForDate;
        List<String> dailyShifts = getShiftsForDate(date);

        for (int i = 0; i < brigadeList.length; i++) {
          String shift = dailyShifts[i % dailyShifts.length];
          String shift2 = dailyShifts[i % dailyShifts.length];

          if (shift == 'Дневная смена (08:00–20:00)') {
            monthlyStats[brigadeList[i]]!['dayShifts'] += 1;
            monthlyStats[brigadeList[i]]!['hours'] += dayShiftHours;
          } else if (shift == 'Ночная смена (20:00–08:00)') {
            monthlyStats[brigadeList[i]]!['nightShifts'] += 1;
            monthlyStats[brigadeList[i]]!['hours'] += nightShiftHours;
          } else if (shift == 'С ночной смены') {
            monthlyStats[brigadeList[i]]!['fromNightShifts'] += 1;
            monthlyStats[brigadeList[i]]!['hours'] += fromNightShiftHours;
          } else if (shift2 == '1-я смена') {
            monthlyStats[brigadeList[i]]!['dayShifts'] += 1;
            monthlyStats[brigadeList[i]]!['hours'] += dayShiftHours;
          } else if (shift2 == '2-я смена') {
            monthlyStats[brigadeList[i]]!['dayShifts'] += 1;
            monthlyStats[brigadeList[i]]!['hours'] += dayShiftHours;
          } else if (shift2 == '1-й выходной') {
            monthlyStats[brigadeList[i]]!['weekend'] += 1;
          } else if (shift2 == '2-й выходной') {
            monthlyStats[brigadeList[i]]!['weekend'] += 1;
          }
        }
      }

      return monthlyStats;
    }

    final provider = context.read<AppDataProvider>();
    final activeBrigades = context.watch<AppDataProvider>().currentBrigades;
    final selectedDate = context.watch<AppDataProvider>().selectedDate;
    final todayShifts = provider.getShiftsForDate(provider.selectedDate);

    int colorBrigadeIndex = 5;
    if (provider.shiftsColrlight == true) {
      colorBrigadeIndex = provider.currentBrigadeIndex;
    }

    Map<String, Map<String, dynamic>> monthlyStats =
        calculateMonthlyStats(selectedDate, activeBrigades);

    return Expanded(
      child: ListView.builder(
        itemCount: activeBrigades.length,
        itemBuilder: (
          context,
          index,
        ) {
          final brigade = activeBrigades[index];
          final stats = monthlyStats[brigade]!;
          final shift = todayShifts[index % todayShifts.length];

          return Card(
            child: ListTile(
              title:
                  Text(brigade, style: Theme.of(context).textTheme.titleLarge),
              subtitle:
                  Text(shift, style: Theme.of(context).textTheme.titleMedium),
              splashColor: Colors.blueAccent,
              leading: colorBrigadeIndex == index
                  ? Icon(
                      Icons.radio_button_on,
                      color: provider.colorsShift(
                          DateTime.now(), provider.currentSchedule),
                    )
                  : const Icon(
                      Icons.radio_button_off,
                      size: 0,
                    ),
              trailing: IconButton(
                onPressed: () {
                  HapticFeedback.vibrate();
                  showShiftDetails(context, brigade, stats);
                },
                icon: Icon(Icons.info, size: 40, color: Colors.blueAccent[100]),
                tooltip: 'Кол-во смен и часов в выбранный месяц',
              ),
              onLongPress: () {
                editBrigadeName(context, index);
              },
              onTap: () {
                HapticFeedback.vibrate();
              },
            ),
          );
        },
      ),
    );
  }
}
