import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/data/models/product_model.dart';
import 'package:cosmatic_app/data/repositories/product_repository.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/features/widgets/product_card.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = ProductRepository();
  final _controller = TextEditingController();
  List<ProductModel> _results = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
        _searched = false;
      });
      return;
    }
    setState(() {
      _loading = true;
      _searched = true;
    });
    try {
      final res = await _repo.getProducts(
        sort: 'newest',
        page: 1,
        perPage: 50,
        search: query.trim(),
      );
      setState(() {
        _results = (res['data'] as List<ProductModel>?) ?? [];
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _results = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ابحث عن منتج...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _results = [];
                        _searched = false;
                      });
                    },
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
          onChanged: (_) => setState(() {}),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _search(_controller.text),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: _loading
            ? const _SearchShimmer()
            : _searched
                ? _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                            SizedBox(height: AppTheme.space3),
                            Text(
                              'لا توجد نتائج',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'جرّب كلمات أخرى',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _search(_controller.text),
                        color: AppColors.gold,
                        child: GridView.builder(
                          padding: EdgeInsets.all(AppTheme.space4),
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _results.length,
                          itemBuilder: (_, i) {
                            final p = _results[i];
                            return ProductCard(
                              product: p,
                              onTap: () => context.push('/products/${p.slug}'),
                              onAddCart: p.hasColors
                                  ? () => context.push('/products/${p.slug}')
                                  : () => context.read<CartProvider>().add(p),
                            );
                          },
                        ),
                      )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 72, color: AppColors.terracotta.withValues(alpha: 0.6)),
                        SizedBox(height: AppTheme.space4),
                        Text(
                          'ابحث عن منتجات التجميل',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppTheme.space6),
                          child: Text(
                            'اكتب اسم المنتج أو الكود واضغط بحث',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

class _SearchShimmer extends StatelessWidget {
  const _SearchShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.stone,
      highlightColor: Colors.white,
      child: GridView.builder(
        padding: EdgeInsets.all(AppTheme.space4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.radiusMedium,
          ),
        ),
      ),
    );
  }
}
