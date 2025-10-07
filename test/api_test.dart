import 'package:flutter_test/flutter_test.dart';
import 'package:product/services/api_service.dart';

void main() {
  group('API Service Tests', () {
    test('Fetch categories should return list of categories', () async {
      try {
        final categories = await ApiService.fetchCategories();
        expect(categories, isNotEmpty);
        expect(categories.first.id, isA<int>());
        expect(categories.first.name, isA<String>());
        print('✅ Categories API working - Found ${categories.length} categories');
        print('First category: ${categories.first.name}');
      } catch (e) {
        print('❌ Categories API failed: $e');
        rethrow;
      }
    });

    test('Fetch products by category should return list of products', () async {
      try {
        // First get a category
        final categories = await ApiService.fetchCategories();
        expect(categories, isNotEmpty);
        
        final categoryId = categories.first.id;
        final products = await ApiService.fetchProductsByCategory(categoryId);
        
        expect(products, isA<List>());
        if (products.isNotEmpty) {
          expect(products.first.id, isA<int>());
          expect(products.first.title, isA<String>());
          print('✅ Products API working - Found ${products.length} products for category ${categories.first.name}');
          print('First product: ${products.first.title}');
        } else {
          print('⚠️ No products found for category ${categories.first.name}');
        }
      } catch (e) {
        print('❌ Products API failed: $e');
        rethrow;
      }
    });
  });
}