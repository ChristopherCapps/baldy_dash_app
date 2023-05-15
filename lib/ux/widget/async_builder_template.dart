import 'package:async_builder/async_builder.dart';
import 'package:flutter/material.dart';

import 'error_message_widget.dart';

class AsyncBuilderTemplate<T> extends AsyncBuilder<T> {
  AsyncBuilderTemplate({
    super.key,
    required super.builder,
    super.future,
    super.stream,
    super.initial,
  }) : super(
          waiting: _waiting,
          error: _error,
        );

  static Widget Function(BuildContext context) get _waiting =>
      (context) => const CircularProgressIndicator();

  static Widget Function(
          BuildContext context, Object error, StackTrace? stackTrace)
      get _error => (context, error, stackTrace) =>
          ErrorMessageWidget.withDefaultsAndStackTrace(
              error.toString(), stackTrace!);
}
