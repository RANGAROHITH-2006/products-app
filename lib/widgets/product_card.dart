import 'package:flutter/material.dart';
import 'package:product/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2D3A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF3E4251),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: _buildProductImage(product),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Category
                    Text(
                      product.category.name,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    // View count and price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.visibility,
                              size: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${(product.id * 10) + 100}', // Mock view count
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            color: Color(0xFF8B5CF6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    String imageUrl = '';
    
    if (product.images.isNotEmpty && 
        product.images.first.isNotEmpty && 
        !product.images.first.contains('placehold.co')) {
      imageUrl = product.images.first;
      print('🖼️ [IMAGE DEBUG] Loading product image: $imageUrl');
    } else {
      // Use category image as fallback
      imageUrl = product.category.image;
      print('🔄 [IMAGE DEBUG] Using category image for product ${product.id}: $imageUrl');
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          print('✅ [IMAGE DEBUG] Image loaded successfully: $imageUrl');
          return child;
        }
        return Container(
          color: const Color(0xFF3E4251),
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ [IMAGE DEBUG] Failed to load image: $imageUrl');
        print('❌ [IMAGE DEBUG] Error: $error');
        
        // Try category image if product image failed
        if (product.images.isNotEmpty && 
            !product.images.first.contains('placehold.co') && 
            imageUrl == product.images.first) {
          final categoryImage = product.category.image;
          print('🔄 [IMAGE DEBUG] Trying category image: $categoryImage');
          
          return Image.network(
            categoryImage,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF3E4251),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image_not_supported,
                      color: Color(0xFF6B7280),
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.title.length > 15 
                          ? '${product.title.substring(0, 15)}...' 
                          : product.title,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        }
        
        return Container(
          color: const Color(0xFF3E4251),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.image_not_supported,
                color: Color(0xFF6B7280),
                size: 32,
              ),
              const SizedBox(height: 4),
              Text(
                'No Image',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}