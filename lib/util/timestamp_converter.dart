import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static DateTime? fromJson(Timestamp? value) => value?.toDate();

  static Timestamp? toJson(DateTime? value) =>
      value != null ? Timestamp.fromDate(value) : null;
}
