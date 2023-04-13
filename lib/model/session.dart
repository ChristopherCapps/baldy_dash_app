import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session.g.dart';

@JsonSerializable()
@immutable
class Session extends Equatable {
  final SessionState state;
  final String id;
  final String name;
  final String? passkey;
  final DateTime? startTime;
  final DateTime? completedTime;

  const Session(
      {required this.id,
      required this.name,
      required this.state,
      this.passkey,
      this.startTime,
      this.completedTime});

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, Object?> toJson() => _$SessionToJson(this);

  @override
  List<Object?> get props => [name, state, passkey, startTime, completedTime];

  @override
  bool get stringify => true;
}

enum SessionState { pending, running, paused, completed }
