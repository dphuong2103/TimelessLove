import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/vertical_space_widget.dart';

class LanguageQuestionTab extends StatefulWidget {
  final String language;
  final void Function(Object? value) handleSelectLanguage;
  final void Function() handleFinishAnswering;
  const LanguageQuestionTab({
    super.key,
    required this.handleSelectLanguage,
    required this.language,
    required this.handleFinishAnswering,
  });
  List<String> get _languages => ['English', 'Vietnamese'];

  List<DropdownMenuItem<String>> get _languagesDropDown =>
      _languages.map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language),
        );
      }).toList();

  @override
  State<LanguageQuestionTab> createState() => _LanguageQuestionTabState();
}

class _LanguageQuestionTabState extends State<LanguageQuestionTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: Colors.black,
            ),
            items: widget._languagesDropDown,
            onChanged: widget.handleSelectLanguage,
            value: widget.language,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(197, 182, 151, 1),
          ),
          onPressed: widget.handleFinishAnswering,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 50),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const VerticalSpace(20),
      ],
    );
  }
}
