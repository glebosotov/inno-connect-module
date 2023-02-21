import 'dart:developer';

import 'package:flutter/material.dart';

import 'pigeon.dart';
import 'presentation/quiz_layout.dart';

void main() => runApp(const MyApp());
final QuizApi api = QuizApi();

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
  List<QuestionModel>? _questions;
  late QuizConfiguration? _quizConfig;
  Future<void> getQuestions() async {
    final QuizConfiguration config = await api.getQuizConfig();
    _quizConfig = config;
    final List<QuestionModel?> questions = await api.getQuestions();
    setState(() {
      _questions = questions
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
                      int.parse(_quizConfig!.seedColor ?? '4CAF50', radix: 16) +
                          0xFF000000,
                    ),
                  ),
                ),
                child: QuizLayout(
                  config: _quizConfig!,
                  questions: _questions!,
                  onDone: (List<AnswerModel> answers) {
                    log(answers.toString());
                    api.sendAnswers(answers);
                  },
                ),
              ),
      ),
    );
  }
}
