import 'package:flutter/material.dart';

navigatorPop(BuildContext context) {
  Navigator.of(context).pop();
}

navigatorPush(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return screen;
  }));
}

navigatorPushReplacement(BuildContext context, Widget screen) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return screen;
  }));
}
