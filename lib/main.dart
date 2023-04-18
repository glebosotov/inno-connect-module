import 'dart:developer';

import 'package:flutter/material.dart';

import 'pigeon.dart';
import 'presentation/presentation.dart';

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
  QuizConfiguration? _quizConfig;
  HubScreenConfiguration? _hubConfig;
  bool _showingQuiz = false;
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

  Future<void> getHubConfig() async {
    final HubScreenConfiguration config = await api.getHubScreenConfig();
    setState(() {
      _hubConfig = config;
    });
  }

  @override
  void initState() {
    getQuestions();
    getHubConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(
              int.parse(_quizConfig?.seedColor ?? '4CAF50', radix: 16) +
                  0xFF000000,
            ),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _questions == null || _hubConfig == null || _quizConfig == null
              ? const CircularProgressIndicator()
              : _showingQuiz
                  ? QuizLayout(
                      config: _quizConfig!,
                      questions: _questions!,
                      onDone: (List<AnswerModel> answers) {
                        log(answers.toString());
                        api.sendAnswers(answers);
                        _showingQuiz = false;
                      },
                    )
                  : HubLayout(
                      config: _hubConfig!,
                      openQuiz: () => setState(() => _showingQuiz = true),
                    ),
        ),
      ),
    );
  }
}
