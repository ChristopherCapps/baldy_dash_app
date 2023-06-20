import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/message.dart';
import '../../model/player.dart';

import 'async_builder_template.dart';
import 'message_widget.dart';

class MessagesListViewWidget extends StatefulWidget {
  final Player _player;
  final Stream<List<Message>> _messages;

  const MessagesListViewWidget(this._player, this._messages, {super.key});

  @override
  State<StatefulWidget> createState() => _MessagesListViewWidget();
}

class _MessagesListViewWidget extends State<MessagesListViewWidget> {
  final ScrollController _listScrollController = ScrollController();
  late final StreamSubscription _streamSubscription;

  Stream<List<Message>> get _messages => widget._messages;
  Player get _player => widget._player;

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = _messages.listen(_onNewMessage);
  }

  void _onNewMessage(final List<Message> messages) => setState(() {
        _scrollToBottom();
      });

  void _scrollToBottom() {
    if (_listScrollController.hasClients) {
      final position = _listScrollController.position.maxScrollExtent;
      _listScrollController.animateTo(
        position,
        duration: const Duration(seconds: 3),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => AsyncBuilderTemplate(
        stream: _messages,
        builder: (context, messages) => ListView.builder(
          controller: _listScrollController,
          itemCount: messages!.length,
          itemBuilder: (context, index) =>
              _buildMessageWidget(context, _player, messages[index]),
        ),
      );

  Widget? _buildMessageWidget(final BuildContext context, final Player player,
          final Message message) =>
      // We want to show the message in this player's feed ONLY if it was
      // targeted to the player's crew, or if it was directly sent to the player
      message.toPlayerId == player.id || message.toPlayerId == null
          ? MessageWidget(message)
          : null;
}
