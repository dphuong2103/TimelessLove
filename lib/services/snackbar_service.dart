import 'package:flutter/material.dart';
import 'package:timeless_love_app/widgets/horizontal_space_widget.dart';

enum SnackbarType { info, error, warning }

void showSnackbar({
  required BuildContext context,
  required String text,
  required SnackbarType type,
  Duration duration = const Duration(seconds: 2),
}) {
  MaterialColor backgroundColor() {
    switch (type) {
      case SnackbarType.info:
        return Colors.teal;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.warning:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  Icon icon() {
    switch (type) {
      case SnackbarType.info:
        return const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        );
      case SnackbarType.error:
        return const Icon(
          Icons.clear,
          color: Colors.white,
        );
      case SnackbarType.warning:
        return const Icon(
          Icons.warehouse_sharp,
          color: Colors.white,
        );
      default:
        return const Icon(Icons.warning);
    }
  }

  var snackBar = SnackBar(
    content: Row(
      children: [
        icon(),
        const HorizontalSpace(10),
        Flexible(child: Text(text)),
      ],
    ),
    backgroundColor: backgroundColor(),
    // behavior: SnackBarBehavior.floating,
    duration: duration,
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void showSnackbarWithoutFloating({
  required BuildContext context,
  required String text,
  required SnackbarType type,
  Duration duration = const Duration(seconds: 2),
}) {
  MaterialColor backgroundColor() {
    switch (type) {
      case SnackbarType.info:
        return Colors.teal;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.warning:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  Icon icon() {
    switch (type) {
      case SnackbarType.info:
        return const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        );
      case SnackbarType.error:
        return const Icon(
          Icons.clear,
          color: Colors.white,
        );
      default:
        return const Icon(Icons.warning);
    }
  }

  var snackBar = SnackBar(
    content: Row(
      children: [
        icon(),
        const HorizontalSpace(10),
        Flexible(
            child: Text(
          text,
          style: TextStyle(
              color:
                  type == SnackbarType.warning ? Colors.black : Colors.white),
        )),
      ],
    ),
    backgroundColor: backgroundColor(),
    // behavior: SnackBarBehavior,
    duration: duration,
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
