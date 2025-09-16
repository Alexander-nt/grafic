import 'package:flutter/material.dart';

void info(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Card(
        child: AlertDialog(
          // title: Text('О приложении :', textAlign: TextAlign.center, style: Theme.of(context).textTheme.displayMedium),
          title: Text('График смен', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          content: const Column(
              mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Divider(),
                Text('разработчик', textAlign: TextAlign.center),
                // Divider(),
                SizedBox(height: 2),
                Text('Alexander Shevchenko', textAlign: TextAlign.center),
                Divider(),
                SizedBox(height: 25),
                Divider(),
                Text('версия приложения', textAlign: TextAlign.center),
                // Divider(),
                Text('b0.6.2', textAlign: TextAlign.center),
                Divider(),
              ],
            ),
             actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Закрыть', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ],
        ),
      );
    },
  );
}