import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import '../../models/user.dart';
import '../../widgets/vertical_space_widget.dart';

class GenderQuestionTab extends StatefulWidget {
  final Gender gender;
  final void Function(Gender? selectedGender) handleSelectGender;
  final void Function() handleFinishAnswering;
  const GenderQuestionTab({
    super.key,
    required this.handleSelectGender,
    required this.gender,
    required this.handleFinishAnswering,
  });

  @override
  State<GenderQuestionTab> createState() => _GenderQuestionTabState();
}

class _GenderQuestionTabState extends State<GenderQuestionTab> {
  String _getGenderName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return appLocale(context).male;
      case Gender.female:
        return appLocale(context).female;
      case Gender.other:
        return appLocale(context).other;
    }
  }

  List<DropdownMenuItem<Gender>> get _genderDropdown =>
      Gender.values.map((gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: Text(_getGenderName(gender)),
        );
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        SizedBox(
          width: 300,
          child: DropdownButtonFormField<Gender>(
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
            items: _genderDropdown,
            onChanged: widget.handleSelectGender,
            value: widget.gender,
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
