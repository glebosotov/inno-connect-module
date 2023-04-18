import 'package:flutter/material.dart';

import '../pigeon.dart';

class AnswerButton extends StatefulWidget {
  const AnswerButton({
    super.key,
    required this.option,
    required this.onTap,
    required this.isChosen,
  });
  final Option option;
  final VoidCallback onTap;
  final bool isChosen;

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  late bool _isChosen = widget.isChosen;
  @override
  void didUpdateWidget(covariant AnswerButton oldWidget) {
    if (_isChosen != widget.isChosen) {
      setState(() {
        _isChosen = widget.isChosen;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isChosen = !_isChosen;
        widget.onTap();
      },
      child: AnimatedContainer(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: (_isChosen
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.background)
              .withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (_isChosen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline)
                .withOpacity(0.5),
          ),
        ),
        // height: 60,
        duration: const Duration(milliseconds: 150),
        child: Text(
          widget.option.text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: (_isChosen
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onBackground)
                    .withOpacity(0.8),
              ),
        ),
      ),
    );
  }
}
