import 'package:pigeon/pigeon.dart';

class QuizModel {
  QuizModel(
    this.questions,
    this.startImageUrl,
    this.endImageUrl,
    this.startTitle,
    this.startDescription,
    this.endTitle,
    this.endDescription,
    this.nextButtonTitle,
    this.seedColor,
  );
  final List<QuestionModel?> questions;
  final String? startImageUrl;
  final String? endImageUrl;
  final String? startTitle;
  final String? startDescription;
  final String? endTitle;
  final String? endDescription;
  final String nextButtonTitle;
  final String? seedColor;
}

class QuestionModel {
  QuestionModel({
    required this.id,
    required this.type,
    this.image,
    required this.title,
    this.description,
    required this.options,
  });
  final String id;
  final QuestionType type;
  final String? image;
  final String title;
  final String? description;
  final List<Option?> options;
}

class Option {
  Option({
    required this.id,
    required this.text,
  });
  final String id;
  final String text;
}

enum QuestionType {
  singleChoice,
}

class AnswerModel {
  AnswerModel({
    required this.questionId,
    this.optionId,
    this.text,
  });
  final String questionId;
  final String? optionId;
  final String? text;
}

@HostApi()
abstract class QuizApi {
  QuizModel getQuiz();

  void sendAnswers(List<AnswerModel> answers);
}
