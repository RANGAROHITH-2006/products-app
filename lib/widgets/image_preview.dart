import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SelectedImagePreview extends StatelessWidget {
  final XFile imageFile;

  const SelectedImagePreview({
    super.key,
    required this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selected Image',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF3E4251),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: kIsWeb
                ? Image.network(
                    imageFile.path,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ [UPLOAD DEBUG] Error loading selected image: $error');
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 48,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Failed to load selected image',
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : FutureBuilder<File>(
                    future: Future.value(File(imageFile.path)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.file(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('❌ [UPLOAD DEBUG] Error loading selected image: $error');
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Failed to load selected image',
                                    style: TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

class UploadedImagePreview extends StatelessWidget {
  final String imageUrl;

  const UploadedImagePreview({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Uploaded Image Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2D3A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF3E4251),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                ),
              ),
              errorWidget: (context, url, error) {
                print('❌ [UPLOAD DEBUG] Error loading uploaded image: $error');
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load uploaded image',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}