import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//切りのいいとこで、書きかけにならないように

void main() => runApp(const ResourceView());

class ResourceView extends StatefulWidget {
  const ResourceView({Key? key}) : super(key: key);
  @override
  ResourceViewState createState() => ResourceViewState();
}

class ResourceViewState extends State<ResourceView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _subjectCollection = <String>[];
  List<Color> _colorCollection = <Color>[];
  List<Appointment> _shiftCollection = <Appointment>[];
  List<CalendarResource> _employeeCollection = <CalendarResource>[];
  List<String> _nameCollection = <String>[];
  _DataSource? _events;

  void _addResourceDetails() {
    _nameCollection = <String>[];
    _nameCollection.add('John');
    _nameCollection.add('Bryan');
    _nameCollection.add('Robert');
    _nameCollection.add('Kenny');
    _nameCollection.add('Tia');
    _nameCollection.add('Theresa');
    _nameCollection.add('Edith');
    _nameCollection.add('Sophia');
  }

  void _addResources() {
    Random random = Random();
    for (int i = 0; i < _nameCollection.length; i++) {
      _employeeCollection.add(CalendarResource(
        displayName: _nameCollection[i],
        id: '000' + i.toString(),
        color: Color.fromRGBO(
            random.nextInt(255), random.nextInt(255), random.nextInt(255), 1),
      ));
    }
  }

  void _addAppointmentDetails() {
    _subjectCollection = <String>[];
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('アルバイト');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF85461E));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
  }

  void _addAppointments() {
    //以下が初期画面用のシフト追加
    _shiftCollection = <Appointment>[];
    final Random random = Random();
    for (int i = 0; i < _employeeCollection.length; i++) {
      final List<String> _employeeIds = <String>[
        _employeeCollection[i].id.toString()
      ];
      if (i == _employeeCollection.length - 1) {
        int index = random.nextInt(5);
        index = index == i ? index + 1 : index;
        _employeeIds.add(_employeeCollection[index].id.toString());
      }

      for (int k = 0; k < 365; k++) {
        if (_employeeIds.length > 1 && k % 2 == 0) {
          continue;
        }

        for (int j = 0; j < 2; j++) {
          final DateTime date = DateTime.now().add(Duration(days: k + j));
          int startHour = 9 + random.nextInt(6);
          startHour =
              startHour >= 13 && startHour <= 14 ? startHour + 1 : startHour;
          final DateTime _shiftStartTime =
              DateTime(date.year, date.month, date.day, startHour, 0, 0);
          _shiftCollection.add(Appointment(
              startTime: _shiftStartTime, //datetimeがたで時間が入っている
              endTime: _shiftStartTime.add(const Duration(hours: 1)),
              subject: _subjectCollection[1],
              color: _colorCollection[random.nextInt(8)],
              startTimeZone: '',
              endTimeZone: '',
              resourceIds: _employeeIds));
        }
      }
    }
  }

  @override
  void initState() {
    _addResourceDetails();
    _addResources();
    _addAppointmentDetails();
    _addAppointments();
    _events = _DataSource(_shiftCollection, _employeeCollection);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              child: const Text('Insert resource'),
              onPressed: () {
                final CalendarResource resource = CalendarResource(
                  displayName: 'Sophia',
                  color: Colors.red,
                  id: '0004',
                );
                _employeeCollection.insert(2, resource);
                _events!.notifyListeners(CalendarDataSourceAction.addResource,
                    <CalendarResource>[resource]);
              },
            ),
            /*
            TextButton(
              child: const Text('Remove resource'),
              onPressed: () {
                final CalendarResource resource = _employeeCollection[0];
                _employeeCollection.remove(resource);
                _events!.notifyListeners(
                    CalendarDataSourceAction.removeResource,
                    <CalendarResource>[resource]);
              },
            ),
            TextButton(
              child: const Text('Reset resource'),
              onPressed: () {
                _employeeCollection = <CalendarResource>[];
                _events!.resources!.clear();
                _employeeCollection.add(CalendarResource(
                    displayName: "Sophia", id: '0004', color: Colors.green));

                _events!.resources!.addAll(_employeeCollection);
                _events!.notifyListeners(CalendarDataSourceAction.resetResource,
                    _employeeCollection);
              },
            ),
            */
            Expanded(
              child: SfCalendar(
                view: CalendarView.timelineWeek,
                showDatePickerButton: true,
                dataSource: _events,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          Appointment? newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定

              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            //ここで追加の処理をかく
            //160-190行を参考に次回作業する

            newListText.resourceIds = ['0001'];
            debugPrint('${newListText}');
            _shiftCollection = <Appointment>[];

            _shiftCollection.add(newListText);

            _events!.notifyListeners(
                CalendarDataSourceAction.addResource, _shiftCollection);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ
  //このページで入力したデータをもとにアポイントメントを作成して、その配列？を渡す
  DateTime selectedTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  // 入力されたテキストをデータとして持つ
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('シフト追加画面'),
        ),
        body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_text, style: TextStyle(color: Colors.blue)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                const SizedBox(
                  //リスト追加ボタン
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Appointment shift = Appointment(
                          startTime: selectedTime,
                          endTime: selectedTime.add(const Duration(hours: 1)),
                          isAllDay: false,
                          subject: _text);

                      debugPrint('${selectedTime}');

                      Navigator.of(context).pop(shift);
                    },
                    child: Text('リスト追加', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                    //キャンセルボタン
                    height: 8),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('キャンセル'),
                  ),
                ),
                const SizedBox(height: 8),
                Text('日付'),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                  ),
                ),
                const SizedBox(height: 8),
                Text('開始時刻'),
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Text("${selectedTime.hour}:${selectedTime.minute}"),
                  ),
                )
              ],
            )));
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? timeofday = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeofday != null && timeofday != selectedTime) {
      setState(() {
        selectedTime = _toDataTime(timeofday);
      });
    }
  }

  _toDataTime(TimeOfDay timeofday) {
    var now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeofday.hour, timeofday.minute);
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }
}
