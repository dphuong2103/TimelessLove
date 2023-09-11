import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  String answer;
  DateTime answeredAt;
  String answeredBy;

  Answer({
    required this.answer,
    required this.answeredAt,
    required this.answeredBy,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'],
      answeredAt: (json['answeredAt'] as Timestamp).toDate(),
      answeredBy: json['answeredBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'answeredAt': answeredAt,
      'answeredBy': answeredBy
    };
  }
}
