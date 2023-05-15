import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String headline;
  final String? details;
  final IconData iconData;

  const ErrorMessageWidget(
      {super.key,
      required this.headline,
      this.details,
      required this.iconData});

  const ErrorMessageWidget.withDefaults(this.details, {super.key})
      : iconData = Icons.error,
        headline = 'Something went wrong.';

  const ErrorMessageWidget.withDefaultsAndStackTrace(
    final String details,
    final StackTrace stackTrace, {
    Key? key,
  }) : this.withDefaults('$details\n$stackTrace}', key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.redAccent,
            size: 50.0,
          ),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .primaryTextTheme
                .titleLarge!
                .copyWith(color: Colors.black),
          ),
          Text(
            details ?? '',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      );
}
