import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';

@immutable
class MessageWidget extends StatelessWidget {
  static final DateFormat _messageTimestampFormat = DateFormat().add_jm();

  final Message _message;

  const MessageWidget(this._message, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: ListTile(
          title: Text(
            _message.senderName,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            _message.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          trailing: Text(_messageTimestamp),
        ),
      );

  String get _messageTimestamp =>
      _messageTimestampFormat.format(_message.timestamp);
}
