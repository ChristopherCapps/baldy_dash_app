import '../model/message.dart';
import '../model/player.dart';
import '../model/racing_snapshot.dart';

import 'race_service.dart';

abstract class MessageService {
  static MessageService of(final RaceService raceService) =>
      _DefaultMessageService(raceService);

  Future<void> sendTaunt(
    Player fromPlayer,
    RacingSnapshot fromRacingSnapshot,
    String text,
  );

  Future<Message> sendMessageFromGameMasterToPlayer(
    Player toPlayer,
    RacingSnapshot toRacingSnapshot,
    String text, {
    String? photoUrl,
  });

  Future<Message> sendMessageFromRaceToPlayer(
    Player toPlayer,
    RacingSnapshot toRacingSnapshot,
    String text, {
    String? photoUrl,
  });

  Future<Message> sendMessageFromRaceToCrew(
      RacingSnapshot toRacingSnapshot, String text,
      {String? photoUrl});

  Future<Message> sendMessageFromGameMasterToCrew(
      RacingSnapshot toRacingSnapshot, String text,
      {String? photoUrl});
}

class _DefaultMessageService implements MessageService {
  final RaceService _raceService;

  _DefaultMessageService(this._raceService);

  @override
  Future<Message> sendMessageFromGameMasterToCrew(
          RacingSnapshot toRacingSnapshot, String text, {String? photoUrl}) =>
      _raceService.sendMessageFromGameMasterToCrew(toRacingSnapshot, text,
          photoUrl: photoUrl);

  @override
  Future<Message> sendMessageFromGameMasterToPlayer(
          Player toPlayer, RacingSnapshot toRacingSnapshot, String text,
          {String? photoUrl}) =>
      _raceService.sendMessageFromGameMasterToPlayer(
          toPlayer, toRacingSnapshot, text,
          photoUrl: photoUrl);

  @override
  Future<Message> sendMessageFromRaceToCrew(
          RacingSnapshot toRacingSnapshot, String text, {String? photoUrl}) =>
      _raceService.sendMessageFromRaceToCrew(toRacingSnapshot, text,
          photoUrl: photoUrl);

  @override
  Future<Message> sendMessageFromRaceToPlayer(
          Player toPlayer, RacingSnapshot toRacingSnapshot, String text,
          {String? photoUrl}) =>
      _raceService.sendMessageFromRaceToPlayer(
          toPlayer, toRacingSnapshot, text);

  @override
  Future<void> sendTaunt(
          Player fromPlayer, RacingSnapshot fromRacingSnapshot, String text) =>
      _raceService.sendTaunt(fromPlayer, fromRacingSnapshot, text);
}
