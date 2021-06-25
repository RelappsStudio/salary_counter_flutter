


import 'dart:developer';

import 'package:path/path.dart';
import 'package:salary_counter/mainCalendarScreen/components/user_and_work_hours_class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper 
{
  
  Future<Database> database() async
  {
    return openDatabase(
      join(await getDatabasesPath(), 'salaryCalc.db'),
      
      onCreate:  (db, version) async
      {
        await db.execute("CREATE TABLE user(id INTEGER PRIMARY KEY, userName TEXT, jobTime REAL, hourlyRateBrutto REAL, hourlyRateNetto REAL, maxDailyWorkHoursPaidNormally REAL, overtimeHourlyRate REAL, employmentType INTEGER, isStudent INTEGER, age INTEGER)");
        await db.execute("CREATE TABLE workEvents(id INTEGER PRIMARY KEY, month INTEGER, year INTEGER, day INTEGER, workHours REAL)");

        return db;
      },
      version: 1,
    );
  }

  Future<int> insertUser(User user) async
  {
    int userId = 0;
    Database _db = await database();
    await _db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      userId = value;
    });
    return userId;
  }

  Future<void> updateUser(User user) async
  {
    Database _db = await database();
    await _db.update('user', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> insertWorkEvent(WorkEvents event) async
  {
    int eventId = 0;
    Database _db = await database();
    await _db.insert('workEvents', event.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      eventId = value;
    });
  }

  Future<void> updateWorkEvent(int id, String workHours) async
  {
    Database _db = await database();
    await _db.rawUpdate("UPDATE workEvents SET workHours = '$workHours' WHERE id = '$id'");
  }

  Future<List<WorkEvents>> getWorkEvents() async
  {
    Database _db = await database();
    List<Map<String, dynamic>> eventMap = await _db.query('workEvents');
    return List.generate(eventMap.length, (index) {
      return WorkEvents(id: eventMap[index]['id'], day: eventMap[index]['day'], month: eventMap[index]['month'], year: eventMap[index]['year'], workHours: (eventMap[index]['workHours']));
    });
  }

  Future<User> getUser() async
  {
    Database _db = await database();
    List<Map<String, dynamic>> dbOutput = await _db.query('user');
    if (dbOutput.isEmpty || dbOutput == null)
      {
        User testUser = User();
        testUser.id = 1;
        testUser.jobTime = 0.75;
        testUser.userName = 'pjoter';
        testUser.age = 22;
        testUser.hourlyRateNetto = 17;
        testUser.hourlyRateBrutto = 20;
        testUser.employmentType = 0;
        testUser.overtimeHourlyRate = 1.5;
        testUser.isStudent = 0;
        testUser.maxDailyWorkHoursPaidNormally = 8;

        await DatabaseHelper().insertUser(testUser);

        return testUser;
      }
    else{
      Map<String, dynamic> singleUser = dbOutput[0];
      return User(id: (singleUser['id']), age: singleUser['age'], employmentType: singleUser['employmentType'], hourlyRateBrutto: (singleUser['hourlyRateBrutto']), hourlyRateNetto: (singleUser['hourlyRateNetto']), isStudent: singleUser['isStudent'], jobTime: (singleUser['jobTime']), maxDailyWorkHoursPaidNormally: (singleUser['maxDailyWorkHoursPaidNormally']), overtimeHourlyRate: (singleUser['overtimeHourlyRate']), userName: singleUser['userName']);
    }




  }

}
//


// return List.generate(1, (index)
//     {
//       return User(id: dbOutput[index]['id'], age: dbOutput[index]['age'], employmentType: int.parse(dbOutput[index]['employmentType']), hourlyRateBrutto: double.parse(dbOutput[index]['hourlyRateBrutto']), hourlyRateNetto: double.parse(dbOutput[index]['hourlyRateNetto']), isStudent: dbOutput[index]['isStudent'], jobTime: double.parse(dbOutput[index]['jobTime']), maxDailyWorkHoursPaidNormally: double.parse(dbOutput[index]['maxDailyWorkHoursPaidNormally']), overtimeHourlyRate: double.parse(dbOutput[index]['overtimeHourlyRate']), userName: dbOutput[index]['userName']);
//     });