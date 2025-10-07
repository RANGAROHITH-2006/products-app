import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product/services/upload_service.dart';

class UploadState {
  final bool isUploading;
  final bool isUploaded;
  final XFile? selectedImage; 
  final String? uploadedImageUrl;
  final String? error;
  final double progress;

  UploadState({
    this.isUploading = false,
    this.isUploaded = false,
    this.selectedImage,
    this.uploadedImageUrl,
    this.error,
    this.progress = 0.0,
  });

  UploadState copyWith({
    bool? isUploading,
    bool? isUploaded,
    XFile? selectedImage,
    String? uploadedImageUrl,
    String? error,
    double? progress,
    bool clearSelectedImage = false,
  }) {
    return UploadState(
      isUploading: isUploading ?? this.isUploading,
      isUploaded: isUploaded ?? this.isUploaded,
      selectedImage: clearSelectedImage ? null : (selectedImage ?? this.selectedImage),
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      error: error,
      progress: progress ?? this.progress,
    );
  }
}

// Upload notifier
class UploadNotifier extends StateNotifier<UploadState> {
  UploadNotifier() : super(UploadState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      print('🔍 [UPLOAD DEBUG] Starting image picker with source: $source');
      
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        print('✅ [UPLOAD DEBUG] Image selected successfully');
        print('📁 [UPLOAD DEBUG] Image path: ${image.path}');
        print('📏 [UPLOAD DEBUG] Image name: ${image.name}');
        
        state = state.copyWith(
          selectedImage: image,
          error: null,
          isUploaded: false,
          uploadedImageUrl: null,
        );
        
        print('🎯 [UPLOAD DEBUG] Image added to state, ready for upload');
      } else {
        print('❌ [UPLOAD DEBUG] No image selected');
      }
    } catch (error) {
      print('💥 [UPLOAD DEBUG] Error picking image: $error');
      state = state.copyWith(
        error: 'Failed to pick image: $error',
        isUploading: false,
      );
    }
  }

  Future<void> uploadSelectedImage() async {
    if (state.selectedImage == null) {
      print('⚠️ [UPLOAD DEBUG] No image selected for upload');
      state = state.copyWith(error: 'No image selected');
      return;
    }

    print('🚀 [UPLOAD DEBUG] Starting upload process...');
    print('📁 [UPLOAD DEBUG] Uploading file: ${state.selectedImage!.path}');
    
    state = state.copyWith(
      isUploading: true,
      error: null,
      progress: 0.0,
    );

    try {
      for (double i = 0.1; i <= 0.8; i += 0.1) {
        state = state.copyWith(progress: i);
        await Future.delayed(const Duration(milliseconds: 200));
      }

      print('🌐 [UPLOAD DEBUG] Calling API to upload image...');
      final imageUrl = await UploadService.uploadImage(state.selectedImage!);
      
      print('✅ [UPLOAD DEBUG] Upload successful!');
      print('🔗 [UPLOAD DEBUG] Uploaded image URL: $imageUrl');

      state = state.copyWith(
        isUploading: false,
        isUploaded: true,
        uploadedImageUrl: imageUrl,
        progress: 1.0,
        clearSelectedImage: true, 
      );
      
      print('🎉 [UPLOAD DEBUG] Upload completed successfully');
      print('🧹 [UPLOAD DEBUG] Selected image cleared, showing only uploaded result');
    } catch (error) {
      print('💥 [UPLOAD DEBUG] Upload failed: $error');
      state = state.copyWith(
        isUploading: false,
        error: error.toString(),
        progress: 0.0,
      );
    }
  }

  void reset() {
    state = UploadState();
  }
}

// Provider instance
final uploadProvider = StateNotifierProvider<UploadNotifier, UploadState>(
  (ref) => UploadNotifier(),
);