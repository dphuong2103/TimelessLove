import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/vertical_space_widget.dart';

class InitiateScreenQuestionTab extends StatefulWidget {
  final String mainQuestion;
  final String? description;
  final Widget child;

  const InitiateScreenQuestionTab({
    super.key,
    required this.mainQuestion,
    this.description,
    required this.child,
  });

  @override
  State<InitiateScreenQuestionTab> createState() =>
      _InitiateScreenQuestionTabState();
}

class _InitiateScreenQuestionTabState extends State<InitiateScreenQuestionTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(70),
        Text(
          widget.mainQuestion,
          style: GoogleFonts.raleway(
            fontSize: 20,
          ),
        ),
        const VerticalSpace(10),
        widget.description != null
            ? Text(
                widget.description!,
                style: GoogleFonts.raleway(
                  fontSize: 15,
                ),
              )
            : Container(),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
