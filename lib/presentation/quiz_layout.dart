import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../main.dart';
import '../pigeon.dart';
import 'answer_button.dart';
import 'button_style.dart';
import 'open_answer_field.dart';

class QuizLayout extends StatefulWidget {
  const QuizLayout({
    super.key,
    required this.questions,
    required this.onDone,
    required this.config,
  });
  final List<QuestionModel> questions;
  final QuizConfiguration config;
  final Function(List<AnswerModel>) onDone;

  @override
  State<QuizLayout> createState() => _QuizLayoutState();
}

class _QuizLayoutState extends State<QuizLayout> {
  final PageController _pageController = PageController();
  List<AnswerModel> _answers = <AnswerModel>[];

  @override
  void initState() {
    api.quizStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 16,
              ),
              SmoothPageIndicator(
                controller: _pageController,
                count: widget.questions.length + 2,
                effect: WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: Theme.of(context).colorScheme.primary,
                  dotColor:
                      Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemCount: widget.questions.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return MetaLayout(
                        title: widget.config.startTitle,
                        description: widget.config.startDescription,
                        imageUrl: widget.config.startImageUrl,
                      );
                    } else if (index == widget.questions.length + 1) {
                      return MetaLayout(
                        title: widget.config.endTitle,
                        description: widget.config.endDescription,
                        imageUrl: widget.config.endImageUrl,
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Text(
                            widget.questions[index - 1].title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (widget.questions[index - 1].description !=
                              null) ...<Widget>[
                            Text(
                              widget.questions[index - 1].description!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                          Expanded(
                            flex: 5,
                            child: _AnswersList(
                              questionId: widget.questions[index - 1].id,
                              options: widget.questions[index - 1].options
                                  .where((Option? element) => element != null)
                                  .cast<Option>()
                                  .toList(),
                              onChanged: (List<AnswerModel> answers) =>
                                  setState(() => _answers = answers),
                              initialAnswers: _answers,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            style: answerButtonStyle(context),
                            onPressed: (_pageController.hasClients &&
                                        _pageController.page == 0) ||
                                    _checkButtonState()
                                ? () async {
                                    await _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    // ignore: no-empty-block
                                    setState(() {});
                                  }
                                : _pageController.hasClients &&
                                        _pageController.page ==
                                            widget.questions.length + 1
                                    ? () => widget.onDone(_answers)
                                    : null,
                            child: Text(widget.config.nextButtonTitle),
                          ),
                          if (!(widget.config.disableSkipButton ?? false) &&
                              _pageController.hasClients &&
                              _pageController.page != 0 &&
                              _pageController.page !=
                                  widget.questions.length + 1)
                            TextButton(
                              onPressed: () => api.skipQuiz(),
                              child: Text(
                                widget.config.skipButtonTitle ?? 'Skip',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkButtonState() {
    if (!_pageController.hasClients) {
      return true;
    }
    final double? page = _pageController.page;
    if (page == 0) {
      return true;
    }
    if (page == null) {
      return false;
    }
    if (page == widget.questions.length + 1) {
      return false;
    }

    final QuestionModel questionIndex = widget.questions[page.toInt() - 1];

    return _answers
        .any((AnswerModel element) => element.questionId == questionIndex.id);
  }
}

class MetaLayout extends StatelessWidget {
  const MetaLayout({
    super.key,
    this.title,
    this.description,
    this.imageUrl,
  });

  final String? title;
  final String? description;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // const Spacer(),
        Text(
          title ?? '',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          description ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
              ),
        ),
        const SizedBox(
          height: 32,
        ),
        if (imageUrl != null)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl ?? ''),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        // const Spacer(),
      ],
    );
  }
}

class _AnswersList extends StatefulWidget {
  const _AnswersList({
    required this.options,
    required this.onChanged,
    required this.questionId,
    required this.initialAnswers,
  });
  final List<Option> options;
  final String questionId;
  final ValueSetter<List<AnswerModel>> onChanged;
  final List<AnswerModel> initialAnswers;

  @override
  State<_AnswersList> createState() => _AnswersListState();
}

class _AnswersListState extends State<_AnswersList> {
  late final List<AnswerModel> _answers = widget.initialAnswers;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => widget
              .options[index].isOpen
          ? OpenAnswerField(
              isChosen: _answers
                  .where((AnswerModel e) => e.questionId == widget.questionId)
                  .any(
                    (AnswerModel element) =>
                        element.optionId == widget.options[index].id,
                  ),
              onChanged: (String answer) {
                setState(() {
                  _answers.removeWhere((AnswerModel element) =>
                      element.questionId == widget.questionId);
                  _answers.add(AnswerModel(
                    questionId: widget.questionId,
                    optionId: widget.options[index].id,
                    text: answer,
                  ));
                  widget.onChanged(_answers);
                });
              },
            )
          : AnswerButton(
              option: widget.options[index],
              onTap: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _answers.removeWhere((AnswerModel element) =>
                      element.questionId == widget.questionId);
                  _answers.add(AnswerModel(
                    questionId: widget.questionId,
                    optionId: widget.options[index].id,
                  ));
                });
                widget.onChanged(_answers);
              },
              isChosen: _answers
                  .where((AnswerModel e) => e.questionId == widget.questionId)
                  .any(
                    (AnswerModel element) =>
                        element.optionId == widget.options[index].id,
                  ),
            ),
      separatorBuilder: (_, __) => const SizedBox(
        height: 8,
      ),
      itemCount: widget.options.length,
      shrinkWrap: true,
    );
  }
}
