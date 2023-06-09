import 'package:flutter/material.dart';

class NamePromptWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  const NamePromptWidget({super.key, required this.onSubmitted});

  @override
  State<NamePromptWidget> createState() => _NamePromptWidget();
}

class _NamePromptWidget extends State<NamePromptWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextField(
            controller: _controller,
            style: const TextStyle(fontSize: 24),
            textCapitalization: TextCapitalization.words,
            maxLength: 20,
            autofocus: true,
            decoration: const InputDecoration(helperText: 'Your Dasher name'),
            onSubmitted: widget.onSubmitted,
          ),
          const SizedBox(height: 15.0),
          _buildSubmitButtonWidget(context),
        ],
      );

  Widget _buildSubmitButtonWidget(final BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () => widget.onSubmitted(_controller.text),
            child: const Text('SUBMIT'),
          ),
        ],
      );
}
