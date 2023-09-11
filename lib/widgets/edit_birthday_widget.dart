import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/services/format_datetime.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';

class EditBirthdayWidget extends StatefulWidget {
  final DateTime birthDay;
  final void Function(DateTime birthDay, BuildContext modalContext)
      handleSubmitBirthDayChange;
  const EditBirthdayWidget({
    super.key,
    required this.birthDay,
    required this.handleSubmitBirthDayChange,
  });

  @override
  State<EditBirthdayWidget> createState() => _EditBirthdayWidgetState();
}

class _EditBirthdayWidgetState extends State<EditBirthdayWidget> {
  DateTime? _birthDay;

  void _handleBirthDayChange(DateTime changedDate, List<int> int) {
    setState(() {
      _birthDay = changedDate;
    });
  }

  @override
  void initState() {
    _birthDay = widget.birthDay;
    super.initState();
  }

  @override
  Widget build(BuildContext editBirthdayContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        Text(
          formatDateVnLocale(_birthDay!),
          style: GoogleFonts.concertOne(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const VerticalSpace(50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(197, 182, 151, 1),
          ),
          onPressed: () {
            widget.handleSubmitBirthDayChange(_birthDay!, editBirthdayContext);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 50,
            ),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
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
              initialDate: widget.birthDay,
              dateFormat: "dd-MMM-yyyy",
              locale: DatePicker.localeFromString('en'),
              onChange: _handleBirthDayChange,
              pickerTheme: DateTimePickerTheme(
                itemTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
                dividerColor: Colors.grey,
                backgroundColor: Theme.of(editBirthdayContext).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
