import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'session.g.dart';

@JsonSerializable()
@immutable
class Session extends Identity {
  final SessionState state;
  final String name;
  final String raceId;
  final String? tagLine;
  final String? passkey;
  final DateTime? startTime;
  final DateTime? completedTime;

  const Session(super.id, super.path,
      {required this.name,
      required this.raceId,
      required this.state,
      this.tagLine,
      this.passkey,
      this.startTime,
      this.completedTime});

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, Object?> toJson() => _$SessionToJson(this);

  String get tagLineOrDefault =>
      tagLine ?? 'The most fun you\'ll ever have in a golf cart!';

  @override
  List<Object?> get props => [name, state, passkey, startTime, completedTime];

  @override
  bool get stringify => true;
}

enum SessionState { pending, running, paused, completed }
