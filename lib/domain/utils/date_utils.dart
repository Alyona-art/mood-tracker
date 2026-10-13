class CalendarDateUtils {
  CalendarDateUtils._();
  
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  static List<int> getDaysPerMonth(int year) {
    final bool isLeap = isLeapYear(year);
    return <int>[
      31,
      if (isLeap) 29 else 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];
  }
}
