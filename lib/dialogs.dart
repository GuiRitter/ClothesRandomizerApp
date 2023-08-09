import 'package:clothes_randomizer_app/utils/logger.dart';
import 'package:flutter/material.dart';

final _log = logger("utils/dialogs");

onDialogCancelPressed({
  required BuildContext context,
}) {
  _log("onDialogCancelPressed").print();

  Navigator.pop(
    context,
  );
}
