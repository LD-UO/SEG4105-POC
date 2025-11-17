import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ai_result.dart';
import '../models/ingredient.dart';

String _ts() => DateTime.now().toIso8601String();

class UploadService {
  UploadService({required this.baseUrl});

  final String baseUrl;

  /// Simple ping endpoint to verify connectivity with backend/AWS.
  Future<String> ping() async {
    if (baseUrl == 'mock') {
      await Future.delayed(const Duration(milliseconds: 200));
      return 'mock pong';
    }

    final uri = Uri.parse('$baseUrl/ping');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Ping failed ${response.statusCode}: ${response.body}');
    }
    return response.body.isEmpty ? 'ok' : response.body;
  }

  Future<AiResult> uploadAndAnalyze(File image) async {
    // Mocked path: skip network and return fixed payload after a short delay.
    if (baseUrl == 'mock') {
      await Future.delayed(const Duration(milliseconds: 600));
      debugPrint('[${_ts()}] uploadAndAnalyze (mock) file=${image.path}');
      return AiResult(
        calories: 595,
        ingredients: const [
          Ingredient(name: 'Flour', grams: 250.0),
          Ingredient(name: 'Sugar', grams: 100.0),
          Ingredient(name: 'Butter', grams: 125.5),
          Ingredient(name: 'Eggs', grams: 120.0),
        ],
        message: 'AI Response',
        analysisId: 'mock-analysis-1',
      );
    }

    final uri = Uri.parse('$baseUrl/analyze');
    debugPrint('[${_ts()}] POST $uri');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    debugPrint('[${_ts()}] /analyze status=${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Upload failed ${response.statusCode}: ${response.body}');
    }

    return AiResult.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> sendFeedback({required String analysisId, required bool liked}) async {
    if (baseUrl == 'mock') {
      await Future.delayed(const Duration(milliseconds: 300));
      debugPrint('[${_ts()}] feedback (mock) id=$analysisId liked=$liked');
      return;
    }

    final uri = Uri.parse('$baseUrl/feedback');
    debugPrint('[${_ts()}] POST $uri liked=$liked');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': analysisId, 'liked': liked}),
    );
    debugPrint('[${_ts()}] /feedback status=${response.statusCode}');

    if (response.statusCode >= 300) {
      throw Exception('Feedback failed ${response.statusCode}: ${response.body}');
    }
  }
}
