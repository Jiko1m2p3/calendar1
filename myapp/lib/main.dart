import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        showNavigationArrow: true,
        dataSource: MeetingDataSource(getAppointments()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return AddSchedulePage();
            }),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  final DateTime startTime2 =
      DateTime(today.year, today.month, today.day, 12, 0, 0);

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'conference',
      color: Colors.blue));

  meetings.add(Appointment(
      startTime: startTime2,
      endTime: endTime,
      subject: 'MTG',
      color: Colors.blue));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class AddSchedulePage extends StatefulWidget {
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedulePage> {
  String _text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add page'),
        ),
        body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        print('push');
                        //値の渡し方が
                        //想定では新しい予定をリストに追加してみたい
                      },
                      child: Text('testbutton')),
                ),
              ],
            )));
  }
}