import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:flutter_app/services/upload_service.dart';
import 'package:flutter_app/models/ai_result.dart';

void main() {
  group('UploadService', () {
    late File tempImage;

    setUpAll(() async {
      // create a small temporary file to simulate image
      final dir = Directory.systemTemp;
      tempImage = File('${dir.path}/test_image.bin');
      await tempImage.writeAsBytes(Uint8List.fromList(List<int>.generate(10, (i) => i)));
    });

    tearDownAll(() async {
      if (await tempImage.exists()) {
        await tempImage.delete();
      }
    });

    test('uploadAndAnalyze returns mock result when baseUrl == "mock"', () async {
      final svc = UploadService(baseUrl: 'mock');
      final AiResult res = await svc.uploadAndAnalyze(tempImage);
      expect(res.calories, 595);
      expect(res.ingredients.length, 4);
      expect(res.analysisId, 'mock-analysis-1');
    });

    test('uploadAndAnalyze parses server response via http client', () async {
      final responsePayload = jsonEncode({
        'calories': 420,
        'message': 'ok',
        'analysisId': 'srv-123',
        'ingredients': [
          {'name': 'Tomato', 'grams': 80.0},
          {'name': 'Cheese', 'grams': 50.5},
        ],
      });

      final mockClient = MockClient((http.Request request) async {
        if (request.url.path.endsWith('/analyze')) {
          return http.Response(responsePayload, 200, headers: {'content-type': 'application/json'});
        }
        return http.Response('not found', 404);
      });

      final svc = UploadService(baseUrl: 'http://example.com', client: mockClient);
      final AiResult res = await svc.uploadAndAnalyze(tempImage);
      expect(res.calories, 420);
      expect(res.analysisId, 'srv-123');
      expect(res.ingredients.length, 2);
      expect(res.ingredients.first.name, 'Tomato');
      expect(res.ingredients.first.grams, 80.0);
    });

    test('sendFeedback posts JSON to /feedback', () async {
      Map<String, dynamic>? capturedBody;
      late Uri capturedUri;
      final mockClient = MockClient((http.Request request) async {
        capturedUri = request.url;
        if (request.url.path.endsWith('/feedback')) {
          capturedBody = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response('', 200);
        }
        return http.Response('not found', 404);
      });

      final svc = UploadService(baseUrl: 'http://example.com', client: mockClient);
      await svc.sendFeedback(analysisId: 'srv-123', liked: true);

      expect(capturedUri.path, endsWith('/feedback'));
      expect(capturedBody, isNotNull);
      expect(capturedBody!['id'], 'srv-123');
      expect(capturedBody!['liked'], true);
    });
  });
}
