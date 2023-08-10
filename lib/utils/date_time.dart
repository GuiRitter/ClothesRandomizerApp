import 'package:clothes_randomizer_app/constants/date_time.dart';
import 'package:intl/intl.dart';

String formmatLastDateTime({
  required DateTime dateTime,
  required String locale,
}) =>
    DateFormat(
      lastDateTimeFormat,
      locale,
    ).format(
      dateTime,
    );

String? getISO8601({
  required DateTime? dateTime,
}) {
  if (dateTime == null) {
    return null;
  }
  return DateFormat(
    "${dateTime.toIso8601String()}${getISO8601TimeZone(
      timeZoneOffsetInMinutes: dateTime.timeZoneOffset.inMinutes,
    )}",
  ).format(
    dateTime,
  );
}

String getISO8601TimeZone({
  required int timeZoneOffsetInMinutes,
}) {
  var hour = timeZoneOffsetInMinutes ~/ 60;
  var minute = timeZoneOffsetInMinutes % 60;

  return "${NumberFormat(
    "+00;-00",
  ).format(
    hour,
  )}:${NumberFormat(
    "00",
  ).format(
    minute,
  )}";
}
