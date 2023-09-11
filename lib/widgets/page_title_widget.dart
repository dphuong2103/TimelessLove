import 'package:flutter/material.dart';
import 'package:timeless_love_app/theme/theme_manager.dart';

class PageTitleWidget extends StatelessWidget {
  final String text;
  const PageTitleWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: ThemeManager.pageTitleTheme,
    );
  }
}
