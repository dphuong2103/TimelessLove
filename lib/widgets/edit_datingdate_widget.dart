import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/date_picker_theme.dart';
import 'package:flutter_holo_date_picker/widget/date_picker_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/services/format_datetime.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';

class EditDatingDateWidget extends StatefulWidget {
  final DateTime startDate;
  final Function(DateTime startDate, BuildContext modalContext)
      handleSubmitStartDateChange;
  const EditDatingDateWidget({
    super.key,
    required this.startDate,
    required this.handleSubmitStartDateChange,
  });

  @override
  State<EditDatingDateWidget> createState() => _EditDatingDateWidgetState();
}

class _EditDatingDateWidgetState extends State<EditDatingDateWidget> {
  DateTime? _startDate;

  void _handleStartDateChange(DateTime changedDate, List<int> int) {
    setState(() {
      _startDate = changedDate;
    });
  }

  @override
  void initState() {
    _startDate = widget.startDate;
    super.initState();
  }

  @override
  Widget build(BuildContext editDatingDateContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        Text(
          formatDateVnLocale(_startDate!),
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
            widget.handleSubmitStartDateChange(
                _startDate!, editDatingDateContext);
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
              initialDate: widget.startDate,
              dateFormat: "dd-MMM-yyyy",
              locale: DatePicker.localeFromString('en'),
              onChange: _handleStartDateChange,
              pickerTheme: DateTimePickerTheme(
                itemTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
                dividerColor: Colors.grey,
                backgroundColor: Theme.of(editDatingDateContext).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
