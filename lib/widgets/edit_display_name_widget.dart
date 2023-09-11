import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/services/get_language_text.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';

class EditDisplayNameWidget extends StatefulWidget {
  final String userName;
  final void Function(String) handleUserNameOnChange;
  final void Function() handleSubmitChangeName;
  const EditDisplayNameWidget({
    required this.userName,
    required this.handleUserNameOnChange,
    required this.handleSubmitChangeName,
    super.key,
  });

  @override
  State<EditDisplayNameWidget> createState() => _EditDisplayNameWidgetState();
}

class _EditDisplayNameWidgetState extends State<EditDisplayNameWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext editDatingDateContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const VerticalSpace(150),
        TextFormField(
          textAlign: TextAlign.center,
          initialValue: widget.userName,
          style: GoogleFonts.concertOne(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          onChanged: widget.handleUserNameOnChange,
          decoration: InputDecoration(
            hintText: appLocale(context).enter_name_hint,
            border: InputBorder.none,
          ),
        ),
        const VerticalSpace(50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(197, 182, 151, 1),
          ),
          onPressed: widget.handleSubmitChangeName,
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
      ],
    );
  }
}
