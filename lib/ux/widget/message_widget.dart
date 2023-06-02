import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';
import '../../model/player.dart';

import '../../service/player_service.dart';
import '../../service/service_registry.dart';

import 'async_builder_template.dart';

@immutable
class MessageWidget extends StatelessWidget {
  static final DateFormat _messageTimestampFormat = DateFormat().add_jm();

  final PlayerService _playerService;
  final Message _message;

  MessageWidget(final Message message, {Key? key})
      : this.custom(ServiceRegistry.I.playerService, message, key: key);

  const MessageWidget.custom(this._playerService, this._message, {super.key});

  @override
  Widget build(BuildContext context) => AsyncBuilderTemplate(
        future: _fromPlayer,
        builder: (context, player) => Container(
          padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              player!.name.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18,
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
        ),
      );

  Future<Player> get _fromPlayer async =>
      _playerService.getPlayer(id: _message.fromPlayerId);

  String get _messageTimestamp =>
      _messageTimestampFormat.format(_message.timestamp);
}
