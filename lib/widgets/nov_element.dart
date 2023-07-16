import 'package:flutter/material.dart';
import '../model/list_item.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';

class NovElement extends StatefulWidget {

  final Function addItem;

  NovElement(this.addItem);

  @override
  State<StatefulWidget> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement>{
  final _courseController = TextEditingController();
  final _terminController = TextEditingController();

  String course ="";
  DateTime termin = DateTime.now();

  void _submitData(){
    if (_courseController.text.isEmpty){
      return;
    }
    final vnesenCourse = _courseController.text;
    final vnesenTermin = termin;

    final newItem = ListItem(id:nanoid(5), course:vnesenCourse, date:vnesenTermin);

    widget.addItem(newItem);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((value) {
      termin = value!;
    });
  }

  void _showTimePicker() {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now()
    ).then((value) =>
    {
      termin =
      new DateTime(termin.year, termin.month, termin.day, value!.hour, value.minute)
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column (
        children: [
          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              labelText: "Course",
            ),
            onSubmitted: (_) => _submitData,
          ),
          TextField(
            controller: _terminController,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Date",
            ),
            onTap: _showDatePicker,
            onSubmitted: (_) => _submitData,
          ),
          TextField(
            controller: _terminController,
            decoration: InputDecoration(
              icon: Icon(Icons.access_time_outlined),
              labelText: "Time",
            ),
            onTap: _showTimePicker,
            onSubmitted: (_) => _submitData,
          ),
          TextButton(
            child: Text("Add"),
            onPressed: _submitData,
          ),
        ],
      ),
    );
  }

}