String formatDate(DateTime dateTime) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final localDate = dateTime.toLocal();
  final day = localDate.day;
  final month = monthNames[localDate.month - 1];
  final year = localDate.year;
  return '$day $month, $year';
}

String formatDaysPassed(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime.toLocal()).inDays;
  final daysPassed = difference < 0 ? 0 : difference;
  return '$daysPassed dy';
}
