// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/services/alert_dialog_service.dart';
import 'package:timeless_love_app/services/api_service.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/services/get_relationship_service.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/services/progress_indicator_service.dart';
import 'package:timeless_love_app/services/snackbar_service.dart';
import 'package:timeless_love_app/widgets/app_title_widget.dart';
import 'package:timeless_love_app/widgets/vertical_space_widget.dart';
import 'package:provider/provider.dart';
import '../models/answer.dart';
import '../models/question.dart';
import '../services/format_datetime.dart';
import '../services/get_language_text.dart';

enum MenuItem { save, delete, cancel }

class AnswerQuestionWidget extends StatefulWidget {
  final int questionNumber;
  final Question question;
  final UpdateQuestionType type;

  const AnswerQuestionWidget({
    super.key,
    required this.question,
    required this.type,
    required this.questionNumber,
  });

  @override
  State<AnswerQuestionWidget> createState() => _AnswerQuestionWidgetState();
}

class _AnswerQuestionWidgetState extends State<AnswerQuestionWidget> {
  String? _partnerAnswer;
  DateTime _createdAt = DateTime.now();
  final _answerController = TextEditingController();
  final _questionTextController = TextEditingController();

  void _handleMenuItemSelect(MenuItem selectedItem) {
    switch (selectedItem) {
      case MenuItem.save:
        _showSaveConfirmDialog();
        break;
      case MenuItem.delete:
        _showDeleteConfirmDialog();
        break;
      case MenuItem.cancel:
        navigatorPop(context);
        break;
    }
  }

  List<PopupMenuEntry<MenuItem>> get menuItems =>
      widget.type == UpdateQuestionType.update
          ? <PopupMenuEntry<MenuItem>>[
              PopupMenuItem<MenuItem>(
                value: MenuItem.save,
                child: Text(appLocale(context).save),
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.delete,
                child: Text(appLocale(context).delete),
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.cancel,
                child: Text(appLocale(context).cancel),
              ),
            ]
          : <PopupMenuEntry<MenuItem>>[
              PopupMenuItem<MenuItem>(
                value: MenuItem.save,
                child: Text(appLocale(context).save),
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.cancel,
                child: Text(appLocale(context).cancel),
              ),
            ];

  @override
  void initState() {
    _questionTextController.text = widget.question.question;
    if (widget.question.answers != null &&
        widget.question.answers!.isNotEmpty) {
      for (var answer in widget.question.answers!) {
        if (answer.answeredBy == AuthService.currentUser!.uid) {
          _answerController.text = answer.answer;
        } else if (answer.answeredBy != AuthService.currentUser!.uid) {
          _partnerAnswer = answer.answer;
        }
      }
    }
    if (widget.type == UpdateQuestionType.add) {
      widget.question.createdAt = _createdAt;
    }

    if (widget.type == UpdateQuestionType.update) {
      _createdAt = widget.question.createdAt;
    }

    super.initState();
  }

  void _showSaveConfirmDialog() {
    if (_questionTextController.text.isEmpty) {
      showSnackbar(
        context: context,
        text: appLocale(context).homescreen_question_hint_input_question,
        type: SnackbarType.error,
      );
      return;
    }

    Future<void> saveAnswer() async {
      if (context.mounted) {
        showCircularProgressIndicator(context);
        widget.question.question = _questionTextController.text;
        if (widget.type == UpdateQuestionType.add) {
          widget.question.question = _questionTextController.text;
          widget.question.createdAt = _createdAt;
        }
        var answer = Answer(
          answer: _answerController.text,
          answeredAt: DateTime.now(),
          answeredBy: AuthService.currentUser!.uid,
        );

        widget.question.updateAnswer(answer);
        await ApiService.updateQuestions(
            context.read<RelationshipProvider>().relationship!.id!,
            widget.question,
            widget.type);
        if (readRelationship(context)?.partner != null) {
          var partnerToken = await ApiService.getUserToken(
              readRelationship(context)!.partner!.uid!);
          if (partnerToken != null) {
            await ApiService.sendNewQuestionNotification(
              partnerToken,
              title: appLocale(context).homescreen_question_new_question_title,
              body: appLocale(context).homescreen_question_new_question_summary,
            );
          }
        }
        navigatorPop(context);
        navigatorPop(context);
        navigatorPop(context);
      }
    }

    handleShowConfirmDialog(
      context,
      text: appLocale(context).dialog_ready_save_answer,
      handleOkClick: saveAnswer,
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future<void> deleteQuestion() async {
          await ApiService.deleteQuestion(
              readRelationship(context)!.id!, widget.question.id!);

          navigatorPop(context);
          navigatorPop(context);
        }

        return AlertDialog(
          content: Text(appLocale(context).dialog_confirm_delete_question),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, appLocale(context).cancel),
              style: TextButton.styleFrom(
                  side: const BorderSide(
                    width: 1.0,
                    color: Color.fromRGBO(197, 182, 152, 1),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromRGBO(197, 182, 152, 1),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(197, 182, 152, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: deleteQuestion,
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppTitleWidget(),
        actions: [
          PopupMenuButton<MenuItem>(
            onSelected: _handleMenuItemSelect,
            itemBuilder: (BuildContext context) => menuItems,
          ),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLines: null,
                controller: _questionTextController,
                decoration: InputDecoration(
                  hintText: appLocale(context)
                      .homescreen_question_hint_input_question,
                  border: InputBorder.none,
                ),
                style: GoogleFonts.brawler(
                  letterSpacing: 1,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const VerticalSpace(10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${appLocale(context).homescreen_question} ${widget.questionNumber} ${formatDateVnLocale(_createdAt)}',
                  style: const TextStyle(
                    letterSpacing: 1,
                    color: Colors.grey,
                  ),
                ),
              ),
              const VerticalSpace(30),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _answerController,
                style: const TextStyle(
                  letterSpacing: 1,
                ),
                decoration: InputDecoration(
                  hintText:
                      appLocale(context).homescreen_question_hint_input_answer,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              const VerticalSpace(40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context
                          .watch<RelationshipProvider>()
                          .relationship
                          ?.partner
                          ?.displayName ??
                      'My love',
                  style: GoogleFonts.inconsolata(
                    fontSize: 18,
                  ),
                ),
              ),
              const VerticalSpace(10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (_partnerAnswer == null || _partnerAnswer!.isEmpty)
                      ? appLocale(context)
                          .homescreen_question_partner_not_answer
                      : _partnerAnswer!,
                  style: GoogleFonts.inconsolata(
                    fontSize: 17,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
