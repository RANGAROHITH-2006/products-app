import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product/models/category_model.dart';
import 'package:product/providers/category_provider.dart';
import 'package:product/providers/product_provider.dart';
import 'package:product/widgets/category_chip.dart';
import 'package:product/widgets/product_card.dart';
import 'package:shimmer/shimmer.dart';
class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final selectedCategory = ref.read(selectedCategoryProvider);
      if (selectedCategory != null) {
        ref.read(productProvider.notifier).loadMore(selectedCategory);
      }
    }
  }

  void _onCategorySelected(CategoryModel category) {
    ref.read(selectedCategoryProvider.notifier).state = category;
    ref.read(productProvider.notifier).fetchProducts(category, refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final productState = ref.watch(productProvider);

    // Auto-load products when default category is selected
    ref.listen(selectedCategoryProvider, (previous, next) {
      if (previous != next && next != null && productState.products.isEmpty) {
        print('🎯 [PRODUCT DEBUG] Auto-loading products for default category: ${next.name}');
        ref.read(productProvider.notifier).fetchProducts(next, refresh: true);
      }
    });

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Categories
              SizedBox(
                height: 50,
                child: categoriesAsync.when(
                  loading: () => _buildCategoryShimmer(),
                  error: (error, stack) => Center(
                    child: Text(
                      'Error loading categories',
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                  data: (categories) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryChip(
                        category: category,
                        isSelected: selectedCategory?.id == category.id,
                        onTap: () => _onCategorySelected(category),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Products
              Expanded(
                child: selectedCategory == null
                    ? const Center(
                        child: Text(
                          'Select a category to view products',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 16,
                          ),
                        ),
                      )
                    : _buildProductGrid(productState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 12),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFF2A2D3A),
            highlightColor: const Color(0xFF3E4251),
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D3A),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _buildProductGrid(ProductState productState) {
    if (productState.products.isEmpty && productState.isLoading) {
      return _buildProductShimmer();
    }

    if (productState.products.isEmpty && productState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading products',
              style: TextStyle(color: Colors.red[400]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final selectedCategory = ref.read(selectedCategoryProvider);
                if (selectedCategory != null) {
                  ref.read(productProvider.notifier).fetchProducts(
                        selectedCategory,
                        refresh: true,
                      );
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: productState.products.length + (productState.isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= productState.products.length) {
          return _buildProductCardShimmer();
        }
        final product = productState.products[index];
        return ProductCard(
          product: product,
          onTap: () {
        
          },
        );
      },
    );
  }
  Widget _buildProductShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => _buildProductCardShimmer(),
    );
  }
  Widget _buildProductCardShimmer() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF2A2D3A),
        highlightColor: const Color(0xFF3E4251),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3E4251),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: const Color(0xFF3E4251),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 80,
                      color: const Color(0xFF3E4251),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 10,
                          width: 40,
                          color: const Color(0xFF3E4251),
                        ),
                        Container(
                          height: 10,
                          width: 30,
                          color: const Color(0xFF3E4251),
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
}