import 'package:flutter/material.dart';
import 'package:product/providers/upload_provider.dart';

class UploadBox extends StatelessWidget {
  final VoidCallback onTap;
  final UploadState uploadState;

  const UploadBox({
    super.key,
    required this.onTap,
    required this.uploadState,
  });

  @override
  Widget build(BuildContext context) {
    // If upload is completed, show success state
    if (uploadState.isUploaded) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Complete!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Image uploaded successfully',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: uploadState.isUploaded ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF8B5CF6),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: uploadState.isUploading
            ? _buildUploadProgress(uploadState.progress)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Color(0xFF8B5CF6),
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload here any png or jpg',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUploadProgress(double progress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            backgroundColor: const Color(0xFF3E4251),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Uploading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}