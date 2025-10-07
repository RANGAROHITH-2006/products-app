import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:product/models/category_model.dart';
import 'package:product/models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.escuelajs.co/api/v1';
  static Future<List<CategoryModel>> fetchCategories({int limit = 8}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories?limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch products by category
  static Future<List<ProductModel>> fetchProductsByCategory(
    int categoryId, {
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/categories/$categoryId/products?limit=$limit&offset=$offset',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => ProductModel.fromJson(json)).toList();

        print('🖼️ [API DEBUG] Fetched ${products.length} products for category $categoryId');
       
        for (int i = 0; i < products.length && i < 3; i++) {
          final product = products[i];
          print('📦 [API DEBUG] Product ${i + 1}: ${product.title}');
          print('🖼️ [API DEBUG] Images (${product.images.length}): ${product.images}');
        }
        
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}