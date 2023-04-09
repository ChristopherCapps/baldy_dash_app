import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './race_service.dart';

abstract class RaceServiceSupport extends RaceService {
  final String playerTranscriptPath;

  RaceServiceSupport({required this.playerTranscriptPath});

  @override
  Future<String> sendMessage(final String text) async {
    final url =
        Uri.https('quest-baldy-dash.ue.r.appspot.com', playerTranscriptPath);
    final response = await http.post(url, body: text);
    return response.headers['location'] ?? '';
  }
}
