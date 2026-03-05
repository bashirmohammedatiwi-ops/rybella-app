import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/widgets/animated_primary_button.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/core/utils/image_url.dart';
import 'package:cosmatic_app/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAddCart;
  final VoidCallback? onWishlist;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddCart,
    this.onWishlist,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = buildImageUrl(product.image);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.radiusMedium,
        child: Container(
          constraints: const BoxConstraints(minWidth: 150, maxWidth: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.radiusMedium,
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: AppTheme.radiusMedium.topLeft),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: imageUrl.isEmpty
                          ? Container(
                              decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                              child: Icon(Icons.image, size: 48, color: Colors.white.withValues(alpha: 0.8)),
                            )
                          : Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    decoration: const BoxDecoration(gradient: AppColors.cardGradient),
                                    child: Center(child: CircularProgressIndicator(color: AppColors.roseGold, strokeWidth: 2)),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                                    child: const Icon(Icons.image, size: 48, color: Colors.white70),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.1)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (product.hasColors)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.roseGold.withValues(alpha: 0.9),
                          borderRadius: AppTheme.radiusPill,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.palette_outlined, size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('${product.colors.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  if (onWishlist != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: onWishlist,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.favorite_border_rounded, size: 20, color: AppColors.peach),
                          ),
                        ),
                      ),
                    ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: AppColors.blushGradient,
                          borderRadius: AppTheme.radiusPill,
                          boxShadow: AppColors.softShadow,
                        ),
                        child: Text(
                          '-${product.discountPercent}%',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                        ),
                      ),
                    ),
                ],
              ),
              ),
              Padding(
                padding: EdgeInsets.all(AppTheme.space2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nameAr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                    ),
                    SizedBox(height: AppTheme.space1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatIQD(product.finalPrice),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.terracotta,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                        ),
                        if (product.discountPercent > 0) ...[
                          SizedBox(width: AppTheme.space1),
                          Text(
                            formatIQD(product.price),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ],
                    ),
                    if (onAddCart != null) ...[
                      SizedBox(height: AppTheme.space2),
                      AnimatedAddToCartButton(
                        label: product.inStock ? 'أضف للسلة' : 'غير متوفر',
                        onPressed: product.inStock ? onAddCart : null,
                        enabled: product.inStock,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
