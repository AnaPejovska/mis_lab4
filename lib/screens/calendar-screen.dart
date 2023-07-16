import 'package:flutter/material.dart';
import 'package:lab4_193052/screens/calendar-utils.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/list_item.dart';

class CalendarScreen extends StatelessWidget {
  late final List<ListItem> exams;

  CalendarScreen({required this.exams});
  late CalendarUtils _calendarUtils =  CalendarUtils(exams);
  bool _hasSubject(DateTime date) {
    return _calendarUtils.hasSubject(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2023),
        lastDay: DateTime.utc(2024),
        focusedDay: _calendarUtils.focusedDay,
        calendarFormat: _calendarUtils.format,
        onFormatChanged: _calendarUtils.onFormatChanged,
        onPageChanged: _calendarUtils.onPageChanged,
        selectedDayPredicate: (day) {
          return isSameDay(_calendarUtils.selectedDay, day);
        },
        onDaySelected: _calendarUtils.onDaySelected,
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          todayBuilder: (context, date, events) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          markerBuilder: (context, date, events) {
            final hasSubject = _hasSubject(date);
            if (hasSubject) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
