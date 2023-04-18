import 'package:flutter/material.dart';

class OpenAnswerField extends StatefulWidget {
  const OpenAnswerField({
    super.key,
    required this.isChosen,
    required this.onChanged,
  });
  final bool isChosen;
  final Function(String) onChanged;

  @override
  State<OpenAnswerField> createState() => _OpenAnswerFieldState();
}

class _OpenAnswerFieldState extends State<OpenAnswerField> {
  late bool _isChosen = widget.isChosen;
  late final TextEditingController _controller = TextEditingController();
  @override
  void didUpdateWidget(covariant OpenAnswerField oldWidget) {
    if (_isChosen != widget.isChosen) {
      setState(() {
        _isChosen = widget.isChosen;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  InputBorder get inputBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: _isChosen
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      controller: _controller,
      onTap: () {
        setState(() {
          _isChosen = !_isChosen;
          widget.onChanged(_controller.text);
        });
      },
      onChanged: (String value) {
        setState(() {
          widget.onChanged(value);
          _isChosen = value.isNotEmpty;
        });
      },
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: (_isChosen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onBackground)
                .withOpacity(0.8),
          ),
      decoration: InputDecoration(
        border: inputBorder,
        fillColor: (_isChosen
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.background)
            .withOpacity(0.6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      ),
    );
  }
}
