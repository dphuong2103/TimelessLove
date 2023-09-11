import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/theme/theme_manager.dart';

class PrimaryTextWidget extends StatelessWidget {
  final String text;
  const PrimaryTextWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.raleway(
        color: COLOR_ACCENT,
        fontSize: 17,
      ),
    );
  }
}
