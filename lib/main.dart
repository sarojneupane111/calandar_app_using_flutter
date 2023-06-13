import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart' show rootBundle, DefaultAssetBundle;

import 'dart:convert';



class Event {        //event class to represent event data
  final String title;
  final DateTime date;

  Event({required this.title, required this.date});
}


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'My Calendar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

 

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  DateTime today = DateTime.now(); // Variable to capture today's date
  final Map<DateTime, List<Event>> _events = {}; // Declare _events map

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    // Handle day selection event
    setState(() {
      today=day;
    });
  }
  bool _isSameDay(DateTime day1, DateTime day2) {
  return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
}

  @override
void initState() {
  super.initState();
  loadEventsFromJson().then((events) {
    setState(() {
      for (var event in events) {
        if (_events.containsKey(event.date)) {
          _events[event.date]?.add(event);
        } else {
          _events[event.date] = [event];
        }
      }
    });
  });
}

Future<List<Event>> loadEventsFromJson() async {
String jsonString = await DefaultAssetBundle.of(context).loadString('assets/events.json');
  List<dynamic> jsonData = jsonDecode(jsonString);

  List<Event> events = jsonData.map((eventData) {
    String title = eventData['title'];
    DateTime date = DateTime.parse(eventData['date']);

    return Event(title: title, date: date);
  }).toList();

  return events;
}

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Welcome to My Calendar"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
    body: content(), // Include the calendar widget here
  );
}







  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text("selsected day="+ today.toString().split(" ")[0]),
          Container(
            child: TableCalendar(
              locale: "en_US", // To change the language of the calendar
              rowHeight: 40, // Row height between each date or day
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true), // To customize the header
              availableGestures: AvailableGestures.all,
              selectedDayPredicate: (day) => _isSameDay(day, today) ,
              focusedDay: today,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              onDaySelected: _onDaySelected,
              eventLoader: (day) => _getEventsForDay(day),            ),
          ),
            SizedBox(height: 20),
    Text("Events for selected day:"),

    Column(
      children: _getEventsForDay(today).map((event) {
       return Text(event.title.toString());
      }).toList(),
      
    ),
        ],
      ),
    );
  }
  List<Event> _getEventsForDay(DateTime day) {
  // Return the events for the given day from the _events map
  return _events[day] ?? [];
}
}
