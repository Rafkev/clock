import 'dart:io';

class Employee {
  String name;
  List<DateTime> clockIns = [];
  List<DateTime> clockOuts = [];

  Employee(this.name);

  void clockIn() {
    clockIns.add(DateTime.now());
    print('Clocked in at ${clockIns.last}');
  }

  void clockOut() {
    clockOuts.add(DateTime.now());
    print('Clocked out at ${clockOuts.last}');
  }

  Duration getTodayTotalHours() {
    var today = DateTime.now();
    var todayClockIns = clockIns.where((dateTime) =>
        dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day);
    var todayClockOuts = clockOuts.where((dateTime) =>
        dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day);

    var total = Duration.zero;
    for (var i = 0; i < todayClockIns.length; i++) {
      var clockIn = todayClockIns.elementAt(i);
      var clockOut = todayClockOuts.elementAt(i);
      total += clockOut.difference(clockIn);
    }
    return total;
  }

  Duration getWeeklyTotalHours() {
    var today = DateTime.now();
    var startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    var endOfWeek = startOfWeek.add(Duration(days: 6));

    var weeklyClockIns = clockIns.where((dateTime) =>
        dateTime.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        dateTime.isBefore(endOfWeek.add(Duration(days: 1))));
    var weeklyClockOuts = clockOuts.where((dateTime) =>
        dateTime.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        dateTime.isBefore(endOfWeek.add(Duration(days: 1))));

    var total = Duration.zero;
    for (var i = 0; i < weeklyClockIns.length; i++) {
      var clockIn = weeklyClockIns.elementAt(i);
      var clockOut = weeklyClockOuts.elementAt(i);
      total += clockOut.difference(clockIn);
    }
    return total;
  }
}

void main() {
  var employees = <String, Employee>{};

  while (true) {
    print('1. Clock In');
    print('2. Clock Out');
    print('3. View Today\'s Total Hours');
    print('4. View Weekly Total Hours');
    print('5. Exit');
    stdout.write('Select an option: ');
    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        clockIn(employees);
        break;
      case 2:
        clockOut(employees);
        break;
      case 3:
        viewTodayTotalHours(employees);
        break;
      case 4:
        viewWeeklyTotalHours(employees);
        break;
      case 5:
        print('Exiting...');
        return;
      default:
        print('Invalid option. Please try again.');
    }
  }
}

void clockIn(Map<String, Employee> employees) {
  stdout.write('Enter employee name: ');
  var name = stdin.readLineSync() ?? '';
  var employee = employees.putIfAbsent(name, () => Employee(name));
  employee.clockIn();
}

void clockOut(Map<String, Employee> employees) {
  stdout.write('Enter employee name: ');
  var name = stdin.readLineSync() ?? '';
  var employee = employees[name];
  if (employee != null) {
    employee.clockOut();
  } else {
    print('Employee not found.');
  }
}

void viewTodayTotalHours(Map<String, Employee> employees) {
  stdout.write('Enter employee name: ');
  var name = stdin.readLineSync() ?? '';
  var employee = employees[name];
  if (employee != null) {
    var totalHours = employee.getTodayTotalHours();
    print('Total working hours today: ${totalHours.inHours} hours ${totalHours.inMinutes % 60} minutes');
  } else {
    print('Employee not found.');
  }
}

void viewWeeklyTotalHours(Map<String, Employee> employees) {
  stdout.write('Enter employee name: ');
  var name = stdin.readLineSync() ?? '';
  var employee = employees[name];
  if (employee != null) {
    var totalHours = employee.getWeeklyTotalHours();
    print('Total working hours this week: ${totalHours.inHours} hours ${totalHours.inMinutes % 60} minutes');
  } else {
    print('Employee not found.');
  }
}
