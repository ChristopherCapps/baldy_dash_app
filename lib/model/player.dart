import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'player.g.dart';

enum Role { admin, user }

@JsonSerializable()
@immutable
class Player extends Equatable {
  final String id;
  final Role role;
  final String? name;

  const Player({required this.id, required this.role, this.name});

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, Object?> toJson() => _$PlayerToJson(this);

  @override
  List<Object> get props => ['name', 'role'];

  @override
  bool get stringify => true;
}
