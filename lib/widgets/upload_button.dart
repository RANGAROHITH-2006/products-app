import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product/providers/upload_provider.dart';

class UploadButton extends StatelessWidget {
  final WidgetRef ref;
  final UploadState uploadState;
  final VoidCallback onSelectImage;

  const UploadButton({
    super.key,
    required this.ref,
    required this.uploadState,
    required this.onSelectImage,
  });

  @override
  Widget build(BuildContext context) {
    // hiding button if uploaded
    if (uploadState.isUploaded) {
      return const SizedBox.shrink();
    }
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: uploadState.isUploading
            ? null
            : uploadState.selectedImage != null
                ? () {
                    print('🚀 [UPLOAD DEBUG] Upload button pressed');
                    ref.read(uploadProvider.notifier).uploadSelectedImage();
                  }
                : onSelectImage,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          uploadState.isUploading 
              ? 'Uploading...' 
              : uploadState.selectedImage != null 
                  ? 'Upload to API'
                  : 'Select Image',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}