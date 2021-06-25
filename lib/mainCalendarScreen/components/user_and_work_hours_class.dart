class User {
  int id;
  String userName; //
  double jobTime; //1 = full; 0.75 = parttime(three quarters); 0.5 = parttime(half); 0.25 = parttime(quarter)
  double hourlyRateBrutto;//
  double hourlyRateNetto;//
  double maxDailyWorkHoursPaidNormally;
  double overtimeHourlyRate; //as percentage. example = hourly rate * overtimeHourlyRate
  int employmentType; //0 = umowa o pracę; 1 umowa zlecenie; 2 umowa o dzieło
  int isStudent; //1= yes; 0= no
  int age;

  Map<String, dynamic> toMap()
  {
    return
        {
          'id': id,
          'userName' : userName,
          'jobTime' : jobTime,
          'hourlyRateBrutto' : hourlyRateBrutto,
          'hourlyRateNetto': hourlyRateNetto,
          'maxDailyWorkHoursPaidNormally': maxDailyWorkHoursPaidNormally,
          'overtimeHourlyRate': overtimeHourlyRate,
          'employmentType': employmentType,
          'isStudent': isStudent,
          'age': age,
        };
  }

  User(
      {this.id,
      this.userName,
      this.jobTime,
      this.hourlyRateBrutto,
      this.hourlyRateNetto,
      this.maxDailyWorkHoursPaidNormally,
      this.overtimeHourlyRate,
      this.employmentType,
      this.isStudent,
      this.age});
}

class WorkEvents
{
  int id;
  int month;
  int year;
  int day;
  double workHours;



  Map<String, dynamic> toMap()
  {
    return
        {
          'id': id,
          'month': month,
          'year': year,
          'day': day,
          'workHours': workHours,
        };

  }

  WorkEvents({this.id, this.month, this.year, this.day, this.workHours});
}