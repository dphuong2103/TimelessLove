import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final Function(
    int questionNumber,
    Question question,
  ) handleSelectQuestion;
  const QuestionWidget({
    super.key,
    required this.question,
    required this.handleSelectQuestion,
    required this.questionNumber,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  void _handleQuestionSelect() {
    widget.handleSelectQuestion(widget.questionNumber, widget.question);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleQuestionSelect,
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text:
                '#${widget.questionNumber < 10 ? '0${widget.questionNumber}' : widget.questionNumber}',
            style: GoogleFonts.dancingScript(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          const TextSpan(text: '  '),
          TextSpan(
            text: widget.question.question,
            style: GoogleFonts.inconsolata(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ]),
      ),
    );
  }
}
