import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:quiver/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:salary_counter/databaseFiles/database_helper.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';
import 'package:salary_counter/profileScreen/components/profile_screen_body.dart';
import 'package:sqflite/sqflite.dart';


class CalendarScreenBody extends StatefulWidget {
  final User user;

  const CalendarScreenBody({Key key, this.user}) : super(key: key);
  @override
  _CalendarScreenBodyState createState() => _CalendarScreenBodyState();
}

class _CalendarScreenBodyState extends State<CalendarScreenBody> {

  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  double _estimatedPay;
  double _workHours;
  double _realWorkHours;
  List<WorkEvents> workEvents = [];


  CalendarCarousel _calendarCarouselNoHeader;

  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {

    },
  );

  @override
  void initState() {
    getWorkEvents();
        super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }



  Future<void> getWorkEvents()
  async {
    var events = await DatabaseHelper().getWorkEvents();

      workEvents = events;

    setWorkEventsOnMap();
  }

  void setWorkEventsOnMap()
  {
    for (WorkEvents event in workEvents)
    {
      _markedDateMap.add(
          new DateTime(event.year, event.month, event.day),
          new Event(
            date: new DateTime(event.year, event.month, event.day),
            title: '${event.workHours} godzin przepracowane',
            icon: _eventIcon,
          ));

      //_realWorkHours += event.workHours;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _workHours = calculateWorkHours();
    _estimatedPay = calculateEstimatedPay();
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        showAddWorkHoursDialog(date);
        events.forEach((event) => log(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      firstDayOfWeek: 1,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
      CircleBorder(side: BorderSide(color: Colors.yellow)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),

      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //custom icon

                new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                          _currentMonth,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                          ),
                        )),
                    ElevatedButton(
                      child: Text('Poprz.'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    ),
                    Container(
                      width: 20,
                    ),
                    ElevatedButton(
                      child: Text('Nast.'),
                      onPressed: () async {
                        await DatabaseHelper().getUser();
                        //log('${ [0]}');
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                        });
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Text('Ilość roboczogodzin w tym miesiącu = $_workHours'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text('Przewidywana wypłata = $_estimatedPay'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text('Przepracowane godziny = $_realWorkHours'),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  child: _calendarCarouselNoHeader,
                ), //
              ],
            ),
          ),
        );
  }

  double calculateEstimatedPay()
  {
    return double.parse('${_workHours * (widget.user.hourlyRateNetto == null ? (widget.user.age <= 26 ? widget.user.hourlyRateBrutto * 0.8 : widget.user.hourlyRateBrutto * 0.7) : widget.user.hourlyRateNetto)}');
  }

  double calculateWorkHours()
  {

    var year = _targetDateTime.year;
    var month = _targetDateTime.month;
    List<String> days = [];

    for (int x = 1; x <= daysInMonth(year, month); x++)
      {
        DateTime date = DateTime(year, month, x);

        switch(DateFormat('EEEE').format(date))
        {
          case 'Saturday' : break;
          case 'Sunday' : break;
          default :
            {
              days.add('day');
            }
            break;
        }
      }

    return days.length * (8 * double.parse('${widget.user.jobTime}'));
  }

  Future<void> showAddWorkHoursDialog(DateTime date) {

    double workHours;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
    {
      return AlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: Text('Wpisz ilość godzin\nprzepracowanych dzisiaj')),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: SingleChildScrollView(
            child: Column(
              children: [
            Container(
            height: 20),
                Text('Wybrana data = ${date.day}/${date.month}/${date.year}'),
                Container(
                    height: 20),
                TextField(
                  onChanged: (value)
                  {
                    workHours = double.parse(value);
                  },

                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp("[,]")),
                    DecimalTextInputFormatter(),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              var _db = DatabaseHelper();
              WorkEvents workEvent = WorkEvents(id: int.parse('${date.day}${date.month}${date.year}') , workHours: workHours, year: date.year, month: date.month, day: date.day);
              if (workHours != null && workHours > 0)
                {
                  await _db.insertWorkEvent(workEvent);
                  log('event inserted');
                  Navigator.of(context).pop();
                  setState(() {
                    _markedDateMap.add(
                        new DateTime(workEvent.year, workEvent.month, workEvent.day),
                        new Event(
                          date: new DateTime(workEvent.year, workEvent.month, workEvent.day),
                          title: '${workEvent.workHours} godzin przepracowane',
                          icon: _eventIcon,
                        ));
                  });
                }
              else
                {
                  log('nothing happened');
                  Navigator.of(context).pop();
                }

            },
              child: Text('Zapisz')),
          Text('Usuń'),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
              child: Text('Anuluj')),
        ],
      );
    },
    );
  }
}
