import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';
import 'get_language_text.dart';

void newQuestionNotification(BuildContext context, Question question) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'Timeless Love Channel',
      title: appLocale(context).homescreen_question_new_question_title,
      body: appLocale(context).homescreen_question_new_question_summary,
      summary: appLocale(context).homescreen_question_new_question_summary,
    ),
  );
}
