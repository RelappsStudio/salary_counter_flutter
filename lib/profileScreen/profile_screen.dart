import 'package:flutter/material.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';
import 'package:salary_counter/profileScreen/components/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  const ProfileScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: ProfileScreenBody(user: user,),
    );
  }
}
