enum DateStatus { past, today, future }

extension DateTimeStatus on DateTime {
  DateStatus get dateStatus {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(this.year, this.month, this.day);

    if (date.isBefore(today)) return DateStatus.past;
    if (date.isAtSameMomentAs(today)) return DateStatus.today;
    return DateStatus.future;
  }

  bool get isPast => dateStatus == DateStatus.past;
  bool get isToday => dateStatus == DateStatus.today;
  bool get isFuture => dateStatus == DateStatus.future;
}
