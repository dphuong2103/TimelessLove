import 'package:flutter/material.dart';
import 'get_language_text.dart';

enum ConfirmDialogResult { ok, cancel }

Future<ConfirmDialogResult?> confirmDialog(
  BuildContext context, {
  required String text,
}) {
  return showDialog<ConfirmDialogResult>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, ConfirmDialogResult.cancel),
            style: TextButton.styleFrom(
                side: const BorderSide(
                  width: 1.0,
                  color: Color.fromRGBO(197, 182, 152, 1),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: Text(
              appLocale(context).cancel,
              style: const TextStyle(
                color: Color.fromRGBO(197, 182, 152, 1),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color.fromRGBO(197, 182, 152, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, ConfirmDialogResult.ok),
            child: Text(
              appLocale(context).yes,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    },
  );
}
