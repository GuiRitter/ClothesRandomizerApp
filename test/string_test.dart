import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'characters to sort with priority',
    () async {
      const allSortsOfCharacters =
          "!\"#\$%&'()*+,-./0 9:;<=>?@A Z[\\]^_`az{|}~σςΣßǲǱǳﬀſK₨�ⅷⅧµΜⓗ◌ͅΙǇǈǉ🐪ᄈ￡h◌ͪhh＾｀⁓⁻₋−‐−–—⸗➖™";
      expect(
        [
          r'\p{Punctuation}',
          r'\p{Separator}',
          r'\p{General_Category=Currency_Symbol}',
          r'\p{General_Category=Math_Symbol}',
          r'\p{General_Category=Modifier_Symbol}',
        ]
            .map(
              (
                mSource,
              ) =>
                  RegExp(
                mSource,
                unicode: true,
              ),
            )
            .fold(
              allSortsOfCharacters,
              (
                previousValue,
                element,
              ) =>
                  previousValue.replaceAll(
                element,
                "",
              ),
            ),
        "09AZazσςΣßǲǱǳﬀſK�ⅷⅧµΜⓗ◌ͅΙǇǈǉ🐪ᄈh◌ͪhh➖™",
      );
    },
  );

  test(
    'join with separator',
    () async {
      final list = [
        'a',
        'b',
      ];

      expect(
        list.join(
          " ",
        ),
        "a b",
      );
    },
  );
}
