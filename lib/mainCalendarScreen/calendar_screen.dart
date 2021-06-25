import 'package:flutter/material.dart';
import 'package:salary_counter/mainCalendarScreen/components/calendar_screen_body.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';
import 'package:salary_counter/profileScreen/profile_screen.dart';

import 'components/quick_settings_drawer.dart';

class CalendarScreen extends StatelessWidget {
  final User user;

  const CalendarScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserDrawer(user: user,),
      appBar: AppBar(
        title: Text('Witaj ${user.userName}'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(user: user,)));
            },
            child: Icon(Icons.account_circle),
          ),
          Container(
            width: 20,
          )

        ],
      ),
      body: CalendarScreenBody(user: user,),
    );
  }
}


