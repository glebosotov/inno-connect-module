import 'package:pigeon/pigeon.dart';

class QuizConfiguration {
  QuizConfiguration(
    this.startImageUrl,
    this.endImageUrl,
    this.startTitle,
    this.startDescription,
    this.endTitle,
    this.endDescription,
    this.nextButtonTitle,
    this.seedColor,
  );
  final String? startImageUrl;
  final String? endImageUrl;
  final String? startTitle;
  final String? startDescription;
  final String? endTitle;
  final String? endDescription;
  final String nextButtonTitle;
  final String? seedColor;
}

class HubScreenConfiguration {
  HubScreenConfiguration({
    required this.news,
    required this.buttons,
    this.deleteButtonConfig,
  });
  final List<NewsItem?> news;
  final List<HubButton?> buttons;
  DeleteDataConfiguration? deleteButtonConfig;
}

class DeleteDataConfiguration {
  DeleteDataConfiguration({
    required this.title,
    required this.confirmationTitle,
    required this.confirmationMessage,
    required this.confirmationButtonTitle,
    required this.cancelButtonTitle,
  });
  final String title;
  final String confirmationTitle;
  final String confirmationMessage;
  final String confirmationButtonTitle;
  final String cancelButtonTitle;
}

class HubButton {
  HubButton({
    required this.title,
    required this.id,
    this.startsQuiz = false,
  });
  final String title;
  final String id;
  final bool startsQuiz;
}

class NewsItem {
  NewsItem({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.dateSecondsFromEpoch,
  });
  final String id;
  final String title;
  final String? description;
  final String? imageUrl;
  final int? dateSecondsFromEpoch;
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
  Option({required this.id, required this.text, this.isOpen = false});
  final bool isOpen;
  final String id;
  final String text;
}

enum QuestionType {
  singleChoice,
  singleChoiceOpen,
  open,
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
  QuizConfiguration getQuizConfig();

  List<QuestionModel> getQuestions();

  HubScreenConfiguration getHubScreenConfig();

  void sendAnswers(List<AnswerModel> answers);

  void quizStarted();

  void hubButtonPressed(String id);

  void newsItemPressed(String id);

  void deleteDataPressed();
}
