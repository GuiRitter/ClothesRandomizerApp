import 'package:clothes_randomizer_app/utils/string.comparator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('characters to sort with priority', () async {
    final list = List.from(
      [
        "Angel",
        "Armorist",
        "Among Us",
        "As We Fall",
        "Am I Evil?",
        "Arrow of Time",
        "A Secret Place",
        "A Matter of Time",
        "A New Age Moving In",
        "As Long as I'm Alive",
        "An Exercise in Debauchery",
      ],
      growable: true,
    );

    list.sort(
      (
        alpha,
        bravo,
      ) =>
          StringComparator.compare(
        alpha: alpha,
        bravo: bravo,
      ),
    );
    expect(
      list[0],
      "A Matter of Time",
    );
    expect(
      list[1],
      "Am I Evil?",
    );
    expect(
      list[2],
      "Among Us",
    );
    expect(
      list[3],
      "A New Age Moving In",
    );
    expect(
      list[4],
      "An Exercise in Debauchery",
    );
    expect(
      list[5],
      "Angel",
    );
    expect(
      list[6],
      "Armorist",
    );
    expect(
      list[7],
      "Arrow of Time",
    );
    expect(
      list[8],
      "A Secret Place",
    );
    expect(
      list[9],
      "As Long as I'm Alive",
    );
    expect(
      list[10],
      "As We Fall",
    );
  });
}
