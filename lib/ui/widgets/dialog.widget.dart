import 'package:flutter/material.dart';

Widget buildRowForMultiChoice({
  required Widget child,
}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
      ],
    );

Widget buildTextButton({
  required String label,
  required void Function() onPressed,
  bool align = false,
}) =>
    TextButton(
      style: align
          ? const ButtonStyle(
              alignment: Alignment.centerRight,
            )
          : null,
      onPressed: onPressed,
      child: Text(
        label,
      ),
    );
