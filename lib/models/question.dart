import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer.dart';

class Question {
  String? id;
  String question;
  DateTime createdAt;
  String createdBy;
  List<Answer>? answers;
  Question({
    required this.question,
    this.answers,
    this.id,
    required this.createdBy,
    required this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer> answers = [];
    List<dynamic>? answersJson = json['answers'];
    if (answersJson != null && answersJson.isNotEmpty) {
      answers = answersJson.map((answerJson) {
        return Answer.fromJson(answerJson);
      }).toList();
    }

    return Question(
      id: json['id'],
      question: json['question'],
      answers: answers,
      createdBy: json['createdBy'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answers': answers?.map((answer) => answer.toJson()).toList(),
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  void updateAnswer(Answer updatedAnswer) {
    if (answers == null) {
      answers = [updatedAnswer];
    } else {
      var answerToUpdateIndex = answers!.indexWhere(
          (answer) => answer.answeredBy == updatedAnswer.answeredBy);
      if (answerToUpdateIndex < 0) {
        answers!.add(updatedAnswer);
      } else {
        answers![answerToUpdateIndex] = updatedAnswer;
      }
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'question': question,
      'answers': answers?.map((answer) => answer.toJson()).toList(),
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  factory Question.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data();
    return Question.fromJson(data!);
  }
}
