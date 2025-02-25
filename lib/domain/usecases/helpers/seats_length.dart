List<String> seatsLength(String tickets) {
  if (tickets.isEmpty) {
    return [];
  }
  return tickets.split(',');
}

String timeChanged(DateTime? time) {
  if (time == null) {
    return '';
  }
  final timeSplit = time.toString().split(' ');
  final timeSplit2 = timeSplit[1].split('.');
  return timeSplit2[0];
}

String dateChanged(DateTime? date) {
  if (date == null) {
    return '';
  }
  final dateSplit = date.toString().split(' ');
  return dateSplit[0];
}
