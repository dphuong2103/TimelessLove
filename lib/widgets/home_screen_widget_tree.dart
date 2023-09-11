import 'package:flutter/material.dart';
import 'package:timeless_love_app/providers/current_user_provider.dart';
import 'package:timeless_love_app/providers/relationship_provider.dart';
import 'package:timeless_love_app/screens/initiate_questions_screen.dart';
import 'package:timeless_love_app/services/api_service.dart';
import 'package:timeless_love_app/services/auth_service.dart';
import '../models/question.dart';
import '../models/relationship.dart';
import '../models/user.dart';
import '../screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../services/navigator_service.dart';
import '../services/progress_indicator_service.dart';
import '../services/snackbar_service.dart';

class HomeScreenWidgetTree extends StatefulWidget {
  const HomeScreenWidgetTree({super.key});

  @override
  State<HomeScreenWidgetTree> createState() => _HomeScreenWidgetTreeState();
}

class _HomeScreenWidgetTreeState extends State<HomeScreenWidgetTree> {
  final Stream<Relationship?> _getRelationshipStream =
      ApiService.getRelationshipStream();
  Future<UserModel?> _getPartner(String uid) => ApiService.getUserDetails(uid);
  final Future<UserModel?> _getCurrentUserDetail =
      ApiService.getUserDetails(AuthService.currentUser!.uid);
  Future<void> _handleFinishAnswering(
      DateTime startDate, DateTime birthDate, String gender) async {
    showCircularProgressIndicator(context);
    var newRelationship = Relationship(
      startDate: startDate,
      users: [AuthService.currentUser!.uid],
    );
    try {
      await ApiService.updateUserUserDetailField({
        'birthDate': birthDate,
        'gender': gender,
      });
      var relationship =
          await ApiService.updateRelationshipDetails(newRelationship);

      var firstQuestion = Question(
        question: 'What was your first impression on your partner?',
        createdAt: DateTime.now(),
        createdBy: AuthService.currentUser?.uid ?? '',
      );

      await ApiService.updateQuestions(
          relationship.id!, firstQuestion, UpdateQuestionType.add);

      if (context.mounted) {
        context.read<RelationshipProvider>().relationship = relationship;
      }
    } catch (e) {
      debugPrint('Error on initial question: $e');
      navigatorPop(context);
      showSnackbar(
        context: context,
        text: e.toString(),
        type: SnackbarType.error,
      );
    } finally {
      navigatorPop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _getCurrentUserDetail,
      builder: (context, currentUserSnapshot) {
        switch (currentUserSnapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          case ConnectionState.active:
            {
              if (currentUserSnapshot.hasError ||
                  currentUserSnapshot.data == null) {
                return ElevatedButton(
                  child: const Text('Current user error'),
                  onPressed: () {
                    AuthService.signOut(context);
                  },
                );
              }
              context.read<CurrentUserProvider>().userWithoutNotify =
                  currentUserSnapshot.data;
            }
            break;
          default:
            return ElevatedButton(
              child: Text(currentUserSnapshot.connectionState.toString()),
              onPressed: () {
                AuthService.signOut(context);
              },
            );
        }

        return StreamBuilder<Relationship?>(
          stream: _getRelationshipStream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
              case ConnectionState.active:
                {
                  if (snapshot.hasError) {
                    return ElevatedButton(
                      child: const Text('Error'),
                      onPressed: () {
                        AuthService.signOut(context);
                      },
                    );
                  } else if (snapshot.data == null) {
                    return InitiateScreen(
                      handleFinishAnswering: _handleFinishAnswering,
                    );
                  } else if (snapshot.data != null) {
                    var relationship = snapshot.data;
                    context
                        .read<RelationshipProvider>()
                        .relationshipWithoutNotify = relationship;
                    var partnerUid = relationship!.users.firstWhere(
                        (uid) => uid != AuthService.currentUser!.uid,
                        orElse: () => '');

                    if (partnerUid.isNotEmpty) {
                      return FutureBuilder<UserModel?>(
                        future: _getPartner(partnerUid),
                        builder: (context, partnerSnapshot) {
                          switch (partnerSnapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case ConnectionState.none:
                              return ElevatedButton(
                                child: const Text('Error'),
                                onPressed: () {
                                  AuthService.signOut(context);
                                },
                              );
                            case ConnectionState.done:
                              {
                                if (partnerSnapshot.hasError) {
                                  return ElevatedButton(
                                    child: const Text('User Error'),
                                    onPressed: () {
                                      AuthService.signOut(context);
                                    },
                                  );
                                } else if (partnerSnapshot.data == null) {
                                  context
                                      .read<RelationshipProvider>()
                                      .relationshipWithoutNotify = null;
                                  return const HomeScreen();
                                } else if (partnerSnapshot.data != null) {
                                  var partner = partnerSnapshot.data;
                                  relationship.partner = partner;
                                  context
                                      .read<RelationshipProvider>()
                                      .relationshipWithoutNotify = relationship;
                                  return const HomeScreen();
                                } else {
                                  return Container();
                                }
                              }

                            default:
                              return ElevatedButton(
                                child:
                                    Text(snapshot.connectionState.toString()),
                                onPressed: () {
                                  AuthService.signOut(context);
                                },
                              );
                          }
                        },
                      );
                    }
                    return const HomeScreen();
                  }
                  return Container();
                }

              case ConnectionState.none:
                return ElevatedButton(
                  child: const Text('Error'),
                  onPressed: () {
                    AuthService.signOut(context);
                  },
                );

              default:
                return ElevatedButton(
                  child: Text(snapshot.connectionState.toString()),
                  onPressed: () {
                    AuthService.signOut(context);
                  },
                );
            }
          },
        );
      },
    );
  }
}
