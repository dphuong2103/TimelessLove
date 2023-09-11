import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/vertical_space_widget.dart';

class DatingTimeQuestionTab extends StatefulWidget {
  final String startDatingDate;
  final void Function(DateTime newDate, List<int> int)
      handleSelectStartDatingDate;
  const DatingTimeQuestionTab(
      {super.key,
      required this.startDatingDate,
      required this.handleSelectStartDatingDate});

  @override
  State<DatingTimeQuestionTab> createState() => _DatingTimeQuestionTabState();
}

class _DatingTimeQuestionTabState extends State<DatingTimeQuestionTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        Text(
          widget.startDatingDate,
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
              lastDate: DateTime(2999, 01, 01),
              initialDate: DateTime.now(),
              dateFormat: "dd-MMM-yyyy",
              locale: DatePicker.localeFromString('en'),
              onChange: widget.handleSelectStartDatingDate,
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
        ),
      ],
    );
  }
}
