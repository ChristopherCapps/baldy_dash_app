import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'player.g.dart';

enum Role { gamemaster, participant }

@JsonSerializable()
@immutable
abstract class Player extends Identity {
  static const newPlayerName = 'New Dasher';

  final Role role;
  final String? crewPath;
  final String name;

  const Player._(
    super.id,
    super.path, {
    required this.role,
    required this.name,
    this.crewPath,
  });

  const factory Player(
    final String id,
    final String path, {
    required Role role,
    required String name,
    final String? crewPath,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  static Map<String, Object?> toJson(final Player player) =>
      _$PlayerToJson(player);

  @override
  List<Object?> get props => [role, name, crewPath];

  @override
  bool get stringify => true;

  Player copyWith({
    String? id,
    Role? role,
    String? crewPath,
    String name,
  });
}

class _Player extends Player {
  const _Player(
    super.id,
    super.path, {
    required super.role,
    required super.name,
    super.crewPath,
  }) : super._();

  @override
  Player copyWith({
    String? id,
    String? path,
    Role? role,
    String? name,
    dynamic crewPath = _Unset,
  }) =>
      _Player(
        id ?? this.id,
        path ?? this.path,
        role: role ?? this.role,
        name: name ?? this.name,
        crewPath: crewPath == _Unset ? this.crewPath : crewPath as String?,
      );
}

class _Unset {}
