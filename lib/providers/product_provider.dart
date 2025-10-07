import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product/models/product_model.dart';
import 'package:product/models/category_model.dart';
import 'package:product/services/api_service.dart';

// Product state to handle pagination
class ProductState {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final int currentOffset;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.currentOffset = 0,
  });

  ProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? hasMore,
    String? error,
    int? currentOffset,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentOffset: currentOffset ?? this.currentOffset,
    );
  }
}

// Product notifier with pagination
class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier(this.ref) : super(ProductState());

  final Ref ref;
  static const int _limit = 20;

  Future<void> fetchProducts(CategoryModel category, {bool refresh = false}) async {
    if (refresh) {
      state = ProductState();
    }

    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final products = await ApiService.fetchProductsByCategory(
        category.id,
        limit: _limit,
        offset: refresh ? 0 : state.currentOffset,
      );

      if (refresh) {
        state = state.copyWith(
          products: products,
          isLoading: false,
          hasMore: products.length == _limit,
          currentOffset: products.length,
        );
      } else {
        final allProducts = [...state.products, ...products];
        state = state.copyWith(
          products: allProducts,
          isLoading: false,
          hasMore: products.length == _limit,
          currentOffset: state.currentOffset + products.length,
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> loadMore(CategoryModel category) async {
    if (state.hasMore && !state.isLoading) {
      await fetchProducts(category);
    }
  }

  void reset() {
    state = ProductState();
  }
}

// Provider instance
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(ref),
);