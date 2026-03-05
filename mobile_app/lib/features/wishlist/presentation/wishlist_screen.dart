import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/core/utils/image_url.dart';
import 'package:cosmatic_app/features/wishlist/presentation/wishlist_provider.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().load();
    });
  }

  static String _imageUrl(String? path) => buildImageUrl(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.pinkLight, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Consumer<WishlistProvider>(
              builder: (_, wish, __) {
                if (wish.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppTheme.space6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.cream, AppColors.sand]),
                            shape: BoxShape.circle,
                            boxShadow: AppColors.softShadow,
                          ),
                          child: Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.sage.withValues(alpha: 0.8)),
                        ),
                        SizedBox(height: AppTheme.space5),
                        Text('قائمة المفضلة فارغة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                        SizedBox(height: AppTheme.space2),
                        Text('أضيفي منتجاتك المفضلة هنا', style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(height: AppTheme.space5),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.go('/home'),
                            borderRadius: AppTheme.radiusMedium,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: AppTheme.space6, vertical: AppTheme.space3),
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradient,
                                borderRadius: AppTheme.radiusMedium,
                                boxShadow: AppColors.cardShadow,
                              ),
                              child: Center(
                                child: Text('تسوق الآن', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.all(AppTheme.space4),
                  itemCount: wish.items.length,
                  itemBuilder: (_, i) {
                    final p = wish.items[i];
                    final url = _imageUrl(p.image);
                    return Container(
                      margin: EdgeInsets.only(bottom: AppTheme.space3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppTheme.radiusMedium,
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: InkWell(
                        onTap: () => context.push('/products/${p.slug}'),
                        borderRadius: AppTheme.radiusMedium,
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.space3),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: AppTheme.radiusSmall,
                                child: url.isEmpty
                                    ? Container(width: 80, height: 80, color: AppColors.pink, child: const Icon(Icons.image))
                                    : CachedNetworkImage(
                                        imageUrl: url,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: AppColors.pink),
                                        errorWidget: (_, __, ___) => Container(color: AppColors.pink, child: const Icon(Icons.image)),
                                      ),
                              ),
                              SizedBox(width: AppTheme.space3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.nameAr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Text(formatIQD(p.finalPrice), style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.gold)),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.red),
                                onPressed: () => wish.remove(p.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined),
                                onPressed: () {
                                  if (p.hasColors) {
                                    context.push('/products/${p.slug}');
                                  } else {
                                    context.read<CartProvider>().add(p);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('تمت الإضافة إلى السلة'), behavior: SnackBarBehavior.floating),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
