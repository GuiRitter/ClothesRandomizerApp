import 'package:flutter/material.dart';
import 'package:flutter_guiritter/util/logger.dart';

final _log = logger("utils/dialogs");

onDialogCancelPressed({
  required BuildContext context,
}) {
  _log("onDialogCancelPressed").print();

  Navigator.pop(
    context,
  );
}
