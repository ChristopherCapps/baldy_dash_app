import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../engine.dart';

import '../../model/crew.dart';
import '../../model/message.dart';
import '../../model/player.dart';

import '../../service/crew_service.dart';
import '../../service/player_service.dart';
import '../../service/service_registry.dart';

import 'async_builder_template.dart';

@immutable
class MessageWidget extends StatelessWidget {
  static final DateFormat _messageTimestampFormat = DateFormat().add_jm();

  final Engine _engine;
  final CrewService _crewService;
  final PlayerService _playerService;
  final Message _message;

  MessageWidget(final Message message, {Key? key})
      : this.custom(Engine.I, ServiceRegistry.I.crewService,
            ServiceRegistry.I.playerService, message,
            key: key);

  const MessageWidget.custom(
    this._engine,
    this._crewService,
    this._playerService,
    this._message, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => AsyncBuilderTemplate(
        future: _getSenderName(_message),
        builder: (context, senderName) => Container(
          padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
          child: ListTile(
            title: Text(
              senderName!,
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

  String get _messageTimestamp =>
      _messageTimestampFormat.format(_message.timestamp);

  Future<String> _getSenderName(final Message message) async =>
      switch (message.messageSenderType) {
        MessageSenderType.race => 'BALDY DASH',
        MessageSenderType.gm => 'THE GAMEMASTER',
        MessageSenderType.player => message.sendingPlayerId == _engine.player.id
            ? 'YOU'
            : await _getPlayerAndCrewSenderNames(message),
      };

  Future<String> _getPlayerAndCrewSenderNames(final Message message) async {
    final player = await _playerService.getPlayer(id: message.sendingPlayerId);
    final crew = await _crewService.getCrewByPath(player.crewPath!);
    return '${player.name} (FROM ${crew.name})';
  }
}
