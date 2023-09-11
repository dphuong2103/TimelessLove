import 'package:flutter/material.dart';
import 'get_language_text.dart';

void handleShowConfirmDialog(
  BuildContext context, {
  required String text,
  Function? handleOkClick,
  Function? handleCancelClick,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(text),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          TextButton(
            onPressed: handleCancelClick != null
                ? () => handleCancelClick()
                : () => Navigator.pop(context, appLocale(context).save),
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
          handleOkClick != null
              ? TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(197, 182, 152, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => handleOkClick(),
                  child: Text(
                    appLocale(context).save,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              : Container(),
        ],
      );
    },
  );
}
