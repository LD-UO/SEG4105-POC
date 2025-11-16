import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/ai_result.dart';
import '../models/ingredient.dart';

class UploadService {
  UploadService({required this.baseUrl});

  final String baseUrl;

  Future<AiResult> uploadAndAnalyze(File image) async {
    // Mocked path: skip network and return fixed payload after a short delay.
    if (baseUrl == 'mock') {
      await Future.delayed(const Duration(milliseconds: 600));
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
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
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
      return;
    }

    final uri = Uri.parse('$baseUrl/feedback');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': analysisId, 'liked': liked}),
    );

    if (response.statusCode >= 300) {
      throw Exception('Feedback failed ${response.statusCode}: ${response.body}');
    }
  }
}
