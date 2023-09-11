import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import '../../widgets/vertical_space_widget.dart';

class BirthDateQuestionTab extends StatefulWidget {
  final String birthDay;
  final void Function(DateTime newDate, List<int> int) handleSelectBirthDay;
  const BirthDateQuestionTab(
      {super.key, required this.birthDay, required this.handleSelectBirthDay});

  @override
  State<BirthDateQuestionTab> createState() => _BirthDateQuestionTabState();
}

class _BirthDateQuestionTabState extends State<BirthDateQuestionTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        Text(
          widget.birthDay,
          style: GoogleFonts.concertOne(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: DatePickerWidget(
              looping: false, // default is not looping
              firstDate: DateTime(1940, 01, 01),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              dateFormat: "dd-MMM-yyyy",
              locale: DatePicker.localeFromString('en'),
              onChange: widget.handleSelectBirthDay,

              pickerTheme: DateTimePickerTheme(
                itemTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
                dividerColor: Colors.grey,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
