import 'package:flutter/material.dart';
import 'package:timeless_love_app/theme/theme_manager.dart';

class AppTitleWidget extends StatelessWidget {
  final String? appTitle;
  const AppTitleWidget({super.key, this.appTitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      appTitle != null ? appTitle! : 'Timeless Love',
      style: ThemeManager.appTitleTheme,
    );
  }
}
