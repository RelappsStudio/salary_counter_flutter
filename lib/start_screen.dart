import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';

import 'databaseFiles/database_helper.dart';
import 'mainCalendarScreen/calendar_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  User user;

  @override
  void initState() {
    getOrCreateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: startApp()),
    );
  }

  Widget startApp()
  {
    if (user == null)
    {
      return CircularProgressIndicator();
    }
    else
    {
      return CalendarScreen(user: user,);
    }
  }

  Future<void> getOrCreateUser() async
  {
    User _user = await DatabaseHelper().getUser();
    setState(() {
      user = _user;
    });
  }

}
