import 'package:flutter_guiritter/extension/date_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'to and fro',
    () async {
      const input = "1970-01-01T21:30:00.000-03:00";

      final dateTime = DateTime.parse(
        input,
      ).toLocal();

      expect(
        dateTime.hour,
        21,
      );

      expect(
        dateTime.toISO8601WithTimeZoneString(),
        input,
      );
    },
  );
}
