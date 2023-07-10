class StringComparator {
  static List<RegExp> charactersWithoutSortPriorityRegexList = [
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
      .toList();

  static int compare({
    required String? alpha,
    required String? bravo,
  }) {
    if ((alpha == null) && (bravo == null)) {
      return 0;
    }
    if (bravo == null) {
      return -1;
    }
    if (alpha == null) {
      return 1;
    }
    if (alpha.isEmpty && bravo.isEmpty) {
      return 0;
    }
    if (bravo.isEmpty) {
      return -1;
    }
    if (alpha.isEmpty) {
      return 1;
    }
    final alphaPriority = removeCharactersBasedOnRegex(
      regex: charactersWithoutSortPriorityRegexList,
      text: alpha,
    );
    final bravoPriority = removeCharactersBasedOnRegex(
      regex: charactersWithoutSortPriorityRegexList,
      text: bravo,
    );
    int compare = alphaPriority.toLowerCase().compareTo(
          bravoPriority.toLowerCase(),
        );
    if (compare != 0) {
      return compare;
    }
    compare = alphaPriority.compareTo(
      bravoPriority,
    );
    if (compare != 0) {
      return compare;
    }
    return alpha.compareTo(
      bravo,
    );
  }

  static String removeCharactersBasedOnRegex(
          {required List<RegExp> regex, required String text}) =>
      regex.fold(
        text,
        (
          previousValue,
          element,
        ) =>
            previousValue.replaceAll(
          element,
          "",
        ),
      );
}
