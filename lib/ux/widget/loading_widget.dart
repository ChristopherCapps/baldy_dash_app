import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Loading, please wait...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const CircularProgressIndicator(
              value: null, // indeterminate
              semanticsLabel: 'Circular progress indicator',
            ),
          ],
        ),
      );
}
