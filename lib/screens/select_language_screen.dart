import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';

import '../models/language.dart';
import '../widgets/vertical_space_widget.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({
    super.key,
    required this.handleSelectLanguage,
    required this.handleFinishAnswering,
    required this.language,
  });
  final void Function(Language? selectedLanguage) handleSelectLanguage;
  final void Function() handleFinishAnswering;
  final Language language;
  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();

  List<DropdownMenuItem<Language>> get languagesDropDown =>
      Language.languageList().map((language) {
        return DropdownMenuItem(
          value: language,
          child: Text(language.name),
        );
      }).toList();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTitleWidget(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const VerticalSpace(150),
              const Text(
                'Select your language',
                style: TextStyle(fontSize: 20),
              ),
              const VerticalSpace(20),
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<Language>(
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
                  items: widget.languagesDropDown,
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
          ),
        ),
      ),
    );
  }
}
