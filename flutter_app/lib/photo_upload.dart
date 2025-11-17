import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ai_preview.dart';
import 'config.dart';
import 'models/ai_result.dart';
import 'services/upload_service.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isUploading = false;
  late final UploadService _service = UploadService(baseUrl: backendBaseUrl);

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() {
        _imageFile = File(picked.path);
      });

      await _analyzeAndNavigate(_imageFile!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _analyzeAndNavigate(File image) async {
    setState(() {
      _isUploading = true;
    });

    try {
      final AiResult result = await _service.uploadAndAnalyze(image);
      if (!context.mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AIPreviewPage(
            imageFile: image,
            result: result,
            uploadService: _service,
          ),
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            _imageFile = null;
          });
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_imageFile!, fit: BoxFit.contain),
                      )
                    : Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('No photo selected')),
                      ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Take Photo'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from Gallery'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),
            if (_isUploading) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
