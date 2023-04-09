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

  const ErrorMessageWidget.withDefaults({super.key, this.details})
      : iconData = Icons.error,
        headline = 'Something went wrong.';

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
