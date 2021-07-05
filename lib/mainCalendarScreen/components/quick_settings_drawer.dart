import 'package:flutter/material.dart';
import 'package:salary_counter/mainCalendarScreen/calendar_screen.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UserDrawer extends StatefulWidget {
  final User user;
  const UserDrawer({
    Key key, this.user,
  }) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(widget.user.userName, style: TextStyle(fontSize: 30)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(AppLocalizations.of(context).chooseEmploymentType, style: TextStyle(fontSize: 20),),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownButton(
                value: widget.user.employmentType,
                  onChanged: (value) {
                  setState(() {
                    widget.user.employmentType = value;
                  });
                  },
                  items: [
                    DropdownMenuItem(child: Text('Umowa o pracę'), value: 0),
                    DropdownMenuItem(child: Text('Umowa o zlecenie'), value: 1),
                    DropdownMenuItem(child: Text('Umowa o dzieło'), value: 2),

                  ] ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(AppLocalizations.of(context).selectAge, style: TextStyle(fontSize: 20),),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownButton(
                  value: widget.user.age,
                  onChanged: (value) {
                    setState(() {
                      widget.user.age = value;
                    });
                  },
                  items: [
                    DropdownMenuItem(child: Text('Wybierz wiek'), value: 0),
                   for (int x = 17; x < 100; x++) DropdownMenuItem (
                     child: Text('$x'),
                     value: x,
                   )
                  ] ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(AppLocalizations.of(context).chooseJobTime, style: TextStyle(fontSize: 20),),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownButton(
                  value: widget.user.jobTime,
                  onChanged: (value) {
                    setState(() {
                      widget.user.jobTime = double.parse('$value');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CalendarScreen(user: widget.user,)));
                    });

                  },
                  items: [
                    DropdownMenuItem(child: Text('Wybierz etat'), value: 0),
                    DropdownMenuItem(child: Text('1'), value: 1),
                    DropdownMenuItem(child: Text('3/4'), value: 0.75),
                    DropdownMenuItem(child: Text('1/2'), value: 0.5),
                    DropdownMenuItem(child: Text('1/4'), value: 0.25),
                  ] ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(AppLocalizations.of(context).selectNetPay, style: TextStyle(fontSize: 20)),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              DropdownButton(
                  value: widget.user.hourlyRateNetto,
                  onChanged: (value) {
                    setState(() {
                      widget.user.hourlyRateNetto = value;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CalendarScreen(user: widget.user,)));
                    });
                  },
                  items: [
                    DropdownMenuItem(child: Text('Wybierz stawkę'), value: 0),
                    for (double x = 10; x < 100; x += 0.5) DropdownMenuItem (
                      child: Text('$x zł'),
                      value: x,
                    )
                  ] ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(AppLocalizations.of(context).drawerWarning),
              ),
            ],
          ),
        ),
      ),
    );
  }
}