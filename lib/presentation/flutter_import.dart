import 'dart:developer';

import 'package:flutter/material.dart';

import '../pigeon.dart';
import 'presentation.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({
    super.key,
    required this.quizConfiguration,
    required this.hubScreenConfiguration,
    required this.questions,
    required this.onQuizDone,
  });
  final QuizConfiguration quizConfiguration;
  final HubScreenConfiguration hubScreenConfiguration;
  final List<QuestionModel> questions;
  final Function(List<AnswerModel>) onQuizDone;

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  bool _showingQuiz = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _showingQuiz
          ? QuizLayout(
              config: widget.quizConfiguration,
              questions: widget.questions,
              onDone: (List<AnswerModel> answers) {
                log(answers.toString());
                widget.onQuizDone(answers);
                _showingQuiz = false;
              },
            )
          : HubLayout(
              config: widget.hubScreenConfiguration,
              openQuiz: () => setState(() => _showingQuiz = true),
            ),
    );
  }
}
