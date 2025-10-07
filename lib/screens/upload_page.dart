import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product/providers/upload_provider.dart';
import 'package:product/widgets/image_picker_modal.dart';
import 'package:product/widgets/image_preview.dart';
import 'package:product/widgets/upload_box.dart';
import 'package:product/widgets/upload_button.dart';
import 'package:product/widgets/upload_status_messages.dart';


class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({super.key});

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1D2B),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1D2B),
              Color(0xFF2A2D3A),
            ],
          ),
        ),
        child: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 4,
            radius: const Radius.circular(2),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildUploadSection(uploadState),
                    const SizedBox(height: 16),
                    _buildSelectedImageSection(uploadState),
                    const SizedBox(height: 16),
                    _buildUploadButtonSection(uploadState),
                    _buildStatusMessages(uploadState),
                    const SizedBox(height: 24),
                    _buildUploadedImageSection(uploadState),
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Upload Image',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUploadSection(UploadState uploadState) {
    return UploadBox(
      onTap: () => _showImagePickerOptions(),
      uploadState: uploadState,
    );
  }

  Widget _buildSelectedImageSection(UploadState uploadState) {
    if (uploadState.selectedImage != null) {
      return Column(
        children: [
          SelectedImagePreview(imageFile: uploadState.selectedImage!),
          const SizedBox(height: 24),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildUploadButtonSection(UploadState uploadState) {
    return UploadButton(
      ref: ref,
      uploadState: uploadState,
      onSelectImage: _showImagePickerOptions,
    );
  }

  Widget _buildStatusMessages(UploadState uploadState) {
    return UploadStatusMessages(
      uploadState: uploadState,
      ref: ref,
    );
  }

  Widget _buildUploadedImageSection(UploadState uploadState) {
    if (uploadState.isUploaded && uploadState.uploadedImageUrl != null) {
      return Column(
        children: [
          const SizedBox(height: 24),
          UploadedImagePreview(imageUrl: uploadState.uploadedImageUrl!),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _showImagePickerOptions() {
    ImagePickerModal.show(context, ref);
  }
}