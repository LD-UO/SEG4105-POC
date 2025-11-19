import 'dart:io';
import 'package:flutter/material.dart';
import 'models/ai_result.dart';
import 'widgets/ingredient_list.dart';
import 'services/upload_service.dart';

class AIPreviewPage extends StatefulWidget {
  final File imageFile;
  final AiResult result;
  final UploadService uploadService;

  const AIPreviewPage({
    super.key,
    required this.imageFile,
    required this.result,
    required this.uploadService,
  });

  @override
  State<AIPreviewPage> createState() => _AIPreviewPageState();
}

class _AIPreviewPageState extends State<AIPreviewPage> {
  bool _sendingFeedback = false;

  Future<void> _sendFeedback(bool liked) async {
    if (widget.result.analysisId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No analysis id for feedback (mocked).')),
      );
      return;
    }

    setState(() {
      _sendingFeedback = true;
    });

    try {
      await widget.uploadService.sendFeedback(
        analysisId: widget.result.analysisId!,
        liked: liked,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(liked ? 'Thanks for the thumbs up!' : 'Feedback noted.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sendingFeedback = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.file(widget.imageFile, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calories: ${widget.result.calories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _sendingFeedback ? null : () => _sendFeedback(false),
                  child: const Icon(Icons.thumb_down),
                ),
                ElevatedButton(
                  onPressed: _sendingFeedback ? null : () => _sendFeedback(true),
                  child: const Icon(Icons.thumb_up),
                ),
              ],
            ),
            const SizedBox(height: 16),
            IngredientListWidget(ingredients: widget.result.ingredients),
            if (widget.result.message != null) ...[
              const SizedBox(height: 8),
              Text(widget.result.message!),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('AI processing complete.')),
                );
                if (!mounted) return;
                // Return to the photo selection/upload screen.
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
