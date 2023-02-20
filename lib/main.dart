import 'dart:developer';

import 'package:flutter/material.dart';

import 'pigeon.dart';
import 'presentation/quiz_layout.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect',
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
        platform: TargetPlatform.iOS,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final QuizApi _api = QuizApi();
  List<QuestionModel>? _questions;
  late QuizModel? _quiz;
  Future<void> getQuestions() async {
    final QuizModel quiz = await _api.getQuiz();
    _quiz = quiz;
    setState(() {
      _questions = quiz.questions
          .where((QuestionModel? element) => element != null)
          .toList()
          .cast<QuestionModel>();
    });
  }

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _questions == null
            ? const SizedBox.shrink()
            : Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Color(
                      int.parse(_quiz!.seedColor ?? '4CAF50', radix: 16) +
                          0xFF000000,
                    ),
                  ),
                ),
                child: QuizLayout(
                  quizModel: _quiz!,
                  quiz: _questions!,
                  onDone: (List<AnswerModel> answers) {
                    log(answers.toString());
                    _api.sendAnswers(answers);
                  },
                ),
              ),
      ),
    );
  }
}
