import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';

@immutable
class MessageWidget extends StatelessWidget {
  static final DateFormat _messageTimestampFormat = DateFormat().add_jm();
  final Message _message;

  const MessageWidget(this._message, {super.key});

  @override
  Widget build(BuildContext context) =>
    Container(child: ListTile(title: ),)

  String _messageTimestamp() => _messageTimestampFormat.format(_message.timestamp);
}
