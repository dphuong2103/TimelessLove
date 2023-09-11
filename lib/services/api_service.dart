// ignore_for_file: non_constant_identifier_names, constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeless_love_app/models/relationship.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import 'package:timeless_love_app/services/get_relationship_service.dart';
import '../models/answer.dart';
import '../models/question.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';

enum UpdateQuestionType { add, update }

enum ConnectionRequestResult {
  alreadyInRelationship,
  relationshipNotFound,
  inputSelfRelationship,
  done,
  error,
}

enum DisconnectFromRelationship { done, error }

const AuthorizationKey =
    'AAAAcu3p7B8:APA91bEk1Rt5hCHvq-VFkmPmeiRQtYgnil55UlymFRKw0S-981ynO8fLhdE1c99jT9ZsYg40RAxw6r0V73-JAw0i8gNSNSdeuUrQ0xrGyIh-R4kmz9sXEmHpxJmIQDc2bx6_9FtDpntN';

class ApiService {
  static const String COLLECTION_USERS = 'users';
  static const String COLLECTION_RELATIONSHIPS = 'relationships';
  static const String COLLECTION_RELATIONSHIP_QUESTIONS = 'questions';
  static const String COLLECTION_RELATIONSHIP_QUESTION_ANSWERS = 'answers';
  static var db = FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get usersCollectionRef =>
      db.collection(COLLECTION_USERS);

  static CollectionReference<Map<String, dynamic>>
      get relationshipsCollectionRef => db.collection(COLLECTION_RELATIONSHIPS);

  static CollectionReference<Map<String, dynamic>> questionsCollectionRef(
      String relationshipId) {
    return relationshipsCollectionRef
        .doc(relationshipId)
        .collection(COLLECTION_RELATIONSHIP_QUESTIONS);
  }

  static CollectionReference<Map<String, dynamic>> answerCollectionRef(
    String relationshipId,
    String questionNumber,
  ) {
    return questionsCollectionRef(relationshipId)
        .doc(questionNumber)
        .collection(COLLECTION_RELATIONSHIP_QUESTION_ANSWERS);
  }

  static Future updateUserDetails({required UserModel user}) {
    return usersCollectionRef.doc(user.uid).set(user.toJson());
  }

  static Future updateUserUserDetailField(Map<String, dynamic> data) {
    return usersCollectionRef
        .doc(AuthService.currentUser!.uid)
        .get()
        .then((doc) {
      if (doc.exists) {
        return usersCollectionRef
            .doc(AuthService.currentUser!.uid)
            .update(data);
      } else {
        return usersCollectionRef.doc(AuthService.currentUser!.uid).set(data);
      }
    });
  }

  static Future<Relationship> updateRelationshipDetails(
      Relationship relationship) async {
    if (relationship.id == null) {
      return relationshipsCollectionRef.add({}).then((document) {
        relationship.id = document.id;
        return relationship;
      }).then(
        (relationship) {
          relationshipsCollectionRef
              .doc(relationship.id)
              .set(relationship.toFirestore());
          return relationship;
        },
      );
    } else {
      return relationshipsCollectionRef
          .doc(relationship.id)
          .set(relationship.toFirestore())
          .then((value) {
        return relationship;
      });
    }
  }

  static Future<UserModel?> getUserDetails(String uid) async {
    return usersCollectionRef.doc(uid).get().then((value) {
      if (value.exists && value.data() != null) {
        return UserModel.fromJson(value.data()!);
      } else {
        return null;
      }
    });
  }

  static Future<Relationship?> getRelationship() async {
    try {
      var relationship = await relationshipsCollectionRef
          .where('users', arrayContains: AuthService.currentUser!.uid)
          .limit(1)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty && value.docs.first.exists) {
          return Relationship.fromJson(value.docs.first.data());
        } else {
          return null;
        }
      });

      if (relationship == null) {
        return relationship;
      }

      for (var uid in relationship.users) {
        if (uid != AuthService.currentUser!.uid) {
          var partner = await getUserDetails(uid);
          relationship.partner = partner;
        }
      }

      return relationship;
    } catch (e) {
      return null;
    }
  }

  static Stream<Relationship?> getRelationshipStream() {
    return relationshipsCollectionRef
        .where('users', arrayContains: AuthService.currentUser!.uid)
        .limit(1)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty && event.docs.first.exists) {
        var relationship = Relationship.fromFirestore(event.docs.first);
        return relationship;
      } else {
        return null;
      }
    });
  }

  static Stream<List<Question>?> getQuestionsStream(
      String relationshipId, BuildContext context) {
    debugPrint('get questions stream');
    return questionsCollectionRef(relationshipId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((event) {
      if (event.docs.isNotEmpty) {
        var questions = event.docs.map((doc) {
          return Question.fromFirestore(doc);
        }).toList();
        questions.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        return questions;
      } else {
        return null;
      }
    });
  }

  static Future<List<Question>?> getQuestions(String relationshipId) {
    return questionsCollectionRef(relationshipId).get().then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.map((doc) {
          Question question = Question.fromFirestore(doc);
          return question;
        }).toList();
      } else {
        return null;
      }
    });
  }

  static Future updateQuestions(
    String relationshipId,
    Question question,
    UpdateQuestionType type,
  ) async {
    if (type == UpdateQuestionType.update) {
      return questionsCollectionRef(relationshipId)
          .doc(question.id)
          .set(question.toFirestore());
    } else {
      return questionsCollectionRef(relationshipId).add({}).then((doc) {
        question.id = doc.id;
        return questionsCollectionRef(relationshipId)
            .doc(question.id)
            .set(question.toFirestore());
      });
    }
  }

  static Future<String?> getUserToken(String uid) async {
    var userDetail = await getUserDetails(uid);
    return userDetail?.fmToken;
  }

  static Future sendNewQuestionNotification(
    String token, {
    required String title,
    required String body,
  }) async {
    try {
      await http
          .post(
            Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'key=$AuthorizationKey',
            },
            body: jsonEncode(
              <String, dynamic>{
                'priority': 10,
                'data': <String, dynamic>{
                  'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                  'status': 'done',
                  'body': body,
                  'title': title,
                },
                'notification': {
                  'title': title,
                  'body': body,
                  'android_channel_id': 'TimelessLove Channel id'
                },
                // "collapse_key": "type_a",
                'to': token
              },
            ),
          )
          .then(
            (value) => {debugPrint('Value of request sent: ${value.body}')},
          );
      debugPrint('notification sent');
    } catch (err) {
      debugPrint('Error sending notification: $err');
    }
  }

  static Future deleteQuestion(
      String relationshipId, String questionsId) async {
    return questionsCollectionRef(relationshipId).doc(questionsId).delete();
  }

  static Future deleteAllQuestions(BuildContext context) async {
    var questions = await getQuestions(readRelationship(context)!.id!);
    if (questions != null && questions.isNotEmpty) {
      for (var question in questions) {
        await deleteQuestion(readRelationship(context)!.id!, question.id!);
      }
    }
  }

  static Future updateAnswerDetails(
    String relationshipId,
    String questionNumber,
    Answer answer,
  ) async {
    return answerCollectionRef(relationshipId, questionNumber)
        .doc(answer.answeredBy)
        .set(answer.toJson());
  }

  static Future<ConnectionRequestResult> connectionRequest(
      String relationshipId, BuildContext context) async {
    try {
      //1: Check if target relationship exists?
      if (relationshipId ==
          context.read<RelationshipProvider>().relationship?.id) {
        return ConnectionRequestResult.inputSelfRelationship;
      }

      var targetRelationship = await relationshipsCollectionRef
          .doc(relationshipId)
          .get()
          .then((value) {
        if (value.exists) {
          return Relationship.fromFirestore(value);
        }
        return null;
      });

      if (targetRelationship == null) {
        return ConnectionRequestResult.relationshipNotFound;
      }

      if (targetRelationship.users.length == 2) {
        return ConnectionRequestResult.alreadyInRelationship;
      }

      //2: delete questions

      await deleteAllQuestions(context);

      //3: delete old relationship
      await relationshipsCollectionRef
          .doc(readRelationship(context)!.id)
          .delete();

      //4: add uid to target relationship
      await relationshipsCollectionRef.doc(relationshipId).update({
        'users': FieldValue.arrayUnion([AuthService.currentUser!.uid])
      });

      //5: modify relationship
      context.read<RelationshipProvider>().relationship = targetRelationship;
      return ConnectionRequestResult.done;
    } catch (e) {
      debugPrint(e.toString());
      return ConnectionRequestResult.error;
    }
  }

  static Future<DisconnectFromRelationship> disconnectionFromRelationship(
      BuildContext context) async {
    try {
      await deleteAllQuestions(context);
      await relationshipsCollectionRef
          .doc(readRelationship(context)!.id)
          .delete();
      return DisconnectFromRelationship.done;
    } catch (e) {
      return DisconnectFromRelationship.error;
    }
  }
}
