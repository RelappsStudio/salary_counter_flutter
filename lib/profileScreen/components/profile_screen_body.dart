import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salary_counter/databaseFiles/database_helper.dart';
import 'package:salary_counter/mainCalendarScreen/calendar_screen.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';

class ProfileScreenBody extends StatefulWidget {
  final User user;

  const ProfileScreenBody({Key key, this.user}) : super(key: key);
  @override
  _ProfileScreenBodyState createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool changeName = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.account_circle, size: 90,),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  changeName ? changeName = false : changeName = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  nameTextOrTextField(),
                  Container(
                    width: 20,
                  ),
                  Icon(Icons.edit, color: Colors.grey,)
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Wybierz rodzaj umowy', style: TextStyle(fontSize: 20),),
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
            Text('Wybierz swój wiek', style: TextStyle(fontSize: 20),),
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
            Text('Wybierz aktualny etat', style: TextStyle(fontSize: 20),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            DropdownButton(
                value: widget.user.jobTime,
                onChanged: (value) {
                  setState(() {
                    widget.user.jobTime = double.parse('$value');

                  });

                },
                items: [
                  DropdownMenuItem(child: Text('Wybierz etat'), value: 0),
                  DropdownMenuItem(child: Text('Pełny'), value: 1),
                  DropdownMenuItem(child: Text('3/4'), value: 0.75),
                  DropdownMenuItem(child: Text('1/2'), value: 0.5),
                  DropdownMenuItem(child: Text('1/4'), value: 0.25),
                ] ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Wpisz stawkę netto', style: TextStyle(fontSize: 20)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 150),
              child: TextField(
                onChanged: (value)
                {
                  setState(() {
                    widget.user.hourlyRateNetto = double.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: '${widget.user.hourlyRateNetto} zł'
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BlacklistingTextInputFormatter(RegExp("[,]")),
                  DecimalTextInputFormatter(),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Wpisz stawkę brutto', style: TextStyle(fontSize: 20)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 150),
              child: TextField(
                onChanged: (value)
                {
                  setState(() {
                    widget.user.hourlyRateBrutto = double.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: '${widget.user.hourlyRateBrutto} zł'
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  BlacklistingTextInputFormatter(RegExp("[,]")),
                  DecimalTextInputFormatter(),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Checkbox(value: widget.user.isStudent == 0 ? false : true, onChanged: (check) {
                setState(() {
                  widget.user.isStudent = (check ? 1 : 0);
                });
              })  ,
                Text('Jestem uczniem/studentem', style: TextStyle(fontSize: 15)),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Wybierz dobową ilość godzin\npo której liczone są nadgodziny', style: TextStyle(fontSize: 20),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            DropdownButton(
                value: widget.user.maxDailyWorkHoursPaidNormally,
                onChanged: (value) {
                  setState(() {
                    widget.user.maxDailyWorkHoursPaidNormally = value;
                  });
                },
                items: [
                  DropdownMenuItem(child: Text('Wybierz ilość'), value: 0),
                  for (int x = 8; x < 15; x++) DropdownMenuItem (
                    child: Text('$x'),
                    value: x,
                  )
                ] ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text('Wybierz procentowy mnożnik nadgodzin', style: TextStyle(fontSize: 20),),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            DropdownButton(
                value: 0,
                onChanged: (value) {
                  setState(() {
                    widget.user.overtimeHourlyRate = value;
                  });
                },
                items: [
                  DropdownMenuItem(child: Text('Wybierz ilość'), value: 0),
                  for (int x = 1; x < 10; x++) DropdownMenuItem (
                    child: Text('1$x\0 %'),
                    value: double.parse('0.$x'),
                  )
                ] ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
                onPressed: () async {
                 await  DatabaseHelper().updateUser(widget.user);
                 final snackBar = SnackBar(content: Text('Zmiany zapisane'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(user: widget.user,)));
                },
                child: Container(
                  width: 200,
                    height: 80,
                    child: Center(child: Text('Zapisz')))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget nameTextOrTextField()
  {
    if (changeName)
      {
        return Container(
          width: 150,
          child: TextField(
            onChanged: (value)
            {
              widget.user.userName = value;
            },
           textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: widget.user.userName,
            ),
          ),
        );
      }
    else
      {
        return Text(widget.user.userName, style: TextStyle(fontSize: 30));
      }
  }

}
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}