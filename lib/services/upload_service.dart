import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';

  static Future<String> uploadImage(XFile imageFile) async {
    try {
      print('🌐 [UPLOAD SERVICE] Starting upload to: $baseUrl/files/upload');
      final uri = Uri.parse('$baseUrl/files/upload');
      final request = http.MultipartRequest('POST', uri);
      
      // Add file to request - works for both mobile and web
      final file = http.MultipartFile.fromBytes(
        'file',
        await imageFile.readAsBytes(),
        filename: imageFile.name,
      );
      request.files.add(file);
      
      print('📎 [UPLOAD SERVICE] File attached: ${imageFile.name}');

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print('📡 [UPLOAD SERVICE] Response status: ${response.statusCode}');
      print('📄 [UPLOAD SERVICE] Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        // The API returns the uploaded file location/URL
        final imageUrl = data['location'] ?? data['url'] ?? '';
        print('✅ [UPLOAD SERVICE] Upload successful, URL: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('💥 [UPLOAD SERVICE] Upload error: $e');
      throw Exception('Error uploading image: $e');
    }
  }
}