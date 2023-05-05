import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Identity extends Equatable {
  final String id;
  final String path;

  const Identity(this.id, this.path);
}
