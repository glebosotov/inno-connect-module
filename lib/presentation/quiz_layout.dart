import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../pigeon.dart';
import 'answer_button.dart';

class QuizLayout extends StatefulWidget {
  const QuizLayout({
    super.key,
    required this.quiz,
    required this.onDone,
    required this.quizModel,
  });
  final List<QuestionModel> quiz;
  final QuizModel quizModel;
  final Function(List<AnswerModel>) onDone;

  @override
  State<QuizLayout> createState() => _QuizLayoutState();
}

class _QuizLayoutState extends State<QuizLayout> {
  final PageController _pageController = PageController();
  List<AnswerModel> _answers = <AnswerModel>[];
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
                count: widget.quiz.length + 2,
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
                  itemCount: widget.quiz.length + 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return MetaLayout(
                        title: widget.quizModel.startTitle,
                        description: widget.quizModel.startDescription,
                        imageUrl: widget.quizModel.startImageUrl,
                      );
                    } else if (index == widget.quiz.length + 1) {
                      return MetaLayout(
                        title: widget.quizModel.endTitle,
                        description: widget.quizModel.endDescription,
                        imageUrl: widget.quizModel.endImageUrl,
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.quiz[index - 1].title,
                              style: Theme.of(context).textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (widget.quiz[index - 1].description !=
                              null) ...<Widget>[
                            Expanded(
                              child: Text(
                                widget.quiz[index - 1].description!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                          Expanded(
                            flex: 5,
                            child: _AnswersList(
                              questionId: widget.quiz[index - 1].id,
                              options: widget.quiz[index - 1].options
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
                      child: ElevatedButton(
                        onPressed: (_pageController.hasClients &&
                                    _pageController.page == 0) ||
                                _checkButtonState()
                            ? () async {
                                await _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                                // ignore: no-empty-block
                                setState(() {});
                              }
                            : _pageController.hasClients &&
                                    _pageController.page ==
                                        widget.quiz.length + 1
                                ? () => widget.onDone(_answers)
                                : null,
                        child: Text(widget.quizModel.nextButtonTitle),
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
    if (page == widget.quiz.length + 1) {
      return false;
    }

    final QuestionModel questionIndex = widget.quiz[page.toInt() - 1];

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
        const Spacer(flex: 2),
        Expanded(
          child: Text(
            title ?? '',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
          flex: 2,
          child: Text(
            description ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(
          height: 32,
        ),
        if (imageUrl != null)
          Expanded(
            flex: 6,
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(imageUrl ?? ''),
                ),
              ],
            ),
          ),
        const Spacer(flex: 2),
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
      itemBuilder: (BuildContext context, int index) => AnswerButton(
        option: widget.options[index],
        onTap: () {
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
        isChosen: _answers.any(
          (AnswerModel element) => element.optionId == widget.options[index].id,
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
