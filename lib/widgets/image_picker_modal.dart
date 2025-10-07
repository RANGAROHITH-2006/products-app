import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product/providers/upload_provider.dart';

class ImagePickerModal {
  static void show(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2D3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF4B5563),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Image Source',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                // Only show camera option on mobile platforms
                if (!kIsWeb) ...[
                  Expanded(
                    child: _SourceOption(
                      ref: ref,
                      label: 'Camera',
                      icon: Icons.camera_alt,
                      source: ImageSource.camera,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: _SourceOption(
                    ref: ref,
                    label: kIsWeb ? 'Select File' : 'Gallery',
                    icon: kIsWeb ? Icons.file_upload : Icons.photo_library,
                    source: ImageSource.gallery,
                  ),
                ),
              ],
            ),
            if (kIsWeb) ...[
              const SizedBox(height: 12),
              const Text(
                'Note: Camera access not available on web',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final WidgetRef ref;
  final String label;
  final IconData icon;
  final ImageSource source;

  const _SourceOption({
    required this.ref,
    required this.label,
    required this.icon,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        print('📷 [UPLOAD DEBUG] Selected image source: $label');
        ref.read(uploadProvider.notifier).pickImage(source);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF3E4251),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF8B5CF6),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}