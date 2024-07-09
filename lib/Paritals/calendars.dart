import 'package:flutter/material.dart';
import 'package:task_manager/Paritals/days.dart';

Widget WeekCalendar(int startDay) {
  return Row(
    children: [
      Container(
        width: 100,
        child: Column(
          children: [
            for (int i = 1; i <= 24; i++)
              Expanded(child: Center(child: Text(i.toString())))
          ],
        ),
      )
    ],
  );
}
