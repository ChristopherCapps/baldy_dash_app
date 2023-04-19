import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'player.g.dart';

enum Role { gamemaster, participant }

@JsonSerializable()
@immutable
abstract class Player extends Equatable {
  final String id;
  final Role role;
  final String? raceId;
  final String? sessionId;
  final String? crewId;
  final String name;

  const Player._({
    required this.id,
    required this.role,
    required this.name,
    this.raceId,
    this.sessionId,
    this.crewId,
  });

  const factory Player({
    required String id,
    required Role role,
    required String name,
    String? raceId,
    String? sessionId,
    String? crewId,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  static Map<String, Object?> toJson(final Player player) =>
      _$PlayerToJson(player);

  @override
  List<Object?> get props => [role, raceId, sessionId, crewId, name];

  @override
  bool get stringify => true;

  Player copyWith({
    String? id,
    Role? role,
    String? raceId,
    String? sessionId,
    String? crewId,
    String name,
  });
}

class _Player extends Player {
  const _Player({
    required super.id,
    required super.role,
    required super.name,
    super.raceId,
    super.sessionId,
    super.crewId,
  }) : super._();

  @override
  Player copyWith({
    String? id,
    Role? role,
    String? name,
    dynamic raceId = _Unset,
    dynamic sessionId = _Unset,
    dynamic crewId = _Unset,
  }) =>
      _Player(
        id: id ?? this.id,
        role: role ?? this.role,
        name: name ?? this.name,
        raceId: raceId == _Unset ? this.raceId : raceId as String?,
        sessionId: sessionId == _Unset ? this.sessionId : sessionId as String?,
        crewId: crewId == _Unset ? this.crewId : crewId as String?,
      );
}

class _Unset {}
