import 'package:flutter/material.dart';
import 'package:timeless_love_app/services/navigator_service.dart';
import 'package:timeless_love_app/widgets/answer_question_widget.dart';
import 'package:timeless_love_app/widgets/empty_list_widget.dart';
import '../../models/question.dart';
import '../../providers/relationship_provider.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/question_widget.dart';
import 'package:provider/provider.dart';

class HomeScreenListTab extends StatefulWidget {
  final Function(int number) setQuestionNumber;
  const HomeScreenListTab({
    super.key,
    required this.setQuestionNumber,
  });

  @override
  State<HomeScreenListTab> createState() => _HomeScreenListTabState();
}

class _HomeScreenListTabState extends State<HomeScreenListTab> {
  late final Stream<List<Question>?> _getQuestionsStream;
  void _handleSelectQuestion(int questionNumber, Question question) {
    navigatorPush(
      context,
      AnswerQuestionWidget(
        question: question,
        type: UpdateQuestionType.update,
        questionNumber: questionNumber,
      ),
    );
  }

  @override
  void initState() {
    _getQuestionsStream = ApiService.getQuestionsStream(
        context.read<RelationshipProvider>().relationship!.id!, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _getQuestionsStream,
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
                  widget.setQuestionNumber(1);
                  return const EmptyListWidget();
                } else if (snapshot.data != null) {
                  widget.setQuestionNumber(snapshot.data!.length + 1);
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: QuestionWidget(
                                questionNumber: index + 1,
                                question: snapshot.data![index],
                                handleSelectQuestion: _handleSelectQuestion,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return Text('Nothing here 1${snapshot.connectionState}');
              }

            default:
              return ElevatedButton(
                child: Text(snapshot.connectionState.toString()),
                onPressed: () {
                  AuthService.signOut(context);
                },
              );
          }
        });
  }
}
