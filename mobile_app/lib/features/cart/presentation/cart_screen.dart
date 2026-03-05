import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/widgets/animated_primary_button.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/core/utils/image_url.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static String _imageUrl(String? path) => buildImageUrl(path);

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.textMuted;
    String h = hex.startsWith('#') ? hex : '#$hex';
    if (h.length == 7) {
      return Color(int.parse(h.substring(1), radix: 16) + 0xFF000000);
    }
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('السلة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
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
        child: Consumer<CartProvider>(
          builder: (_, cart, __) {
            if (cart.items.isEmpty) {
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
                      child: Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.sage.withValues(alpha: 0.8)),
                    ),
                    SizedBox(height: AppTheme.space5),
                    Text('سلة التسوق فارغة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: AppTheme.space2),
                    Text('أضيفي منتجاتك المفضلة للسلة', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: AppTheme.space5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.space8),
                      child: AnimatedPrimaryButton(
                        label: 'تسوق الآن',
                        onPressed: () => context.go('/home'),
                        fullWidth: true,
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(AppTheme.space4),
                    itemCount: cart.items.length,
                    itemBuilder: (_, i) {
                      final item = cart.items[i];
                      final url = _imageUrl(item.product.image);
                      return Container(
                        margin: EdgeInsets.only(bottom: AppTheme.space3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppTheme.radiusMedium,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(AppTheme.space3),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: AppTheme.radiusSmall,
                                child: url.isEmpty
                                    ? Container(
                                        width: 88,
                                        height: 88,
                                        decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                                        child: const Icon(Icons.image, color: Colors.white70),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: url,
                                        width: 88,
                                        height: 88,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: AppColors.pinkLight),
                                        errorWidget: (_, __, ___) => Container(
                                          decoration: const BoxDecoration(gradient: AppColors.premiumAccent),
                                          child: const Icon(Icons.image, color: Colors.white70),
                                        ),
                                      ),
                              ),
                              SizedBox(width: AppTheme.space3),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.nameAr,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    if (item.selectedColor != null)
                                      Padding(
                                        padding: EdgeInsets.only(bottom: AppTheme.space1),
                                        child: Row(
                                          children: [
                                            if (item.selectedColor!.hexCode != null && item.selectedColor!.hexCode!.isNotEmpty)
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: BoxDecoration(
                                                  color: CartScreen._parseColor(item.selectedColor!.hexCode),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: AppColors.textMuted, width: 1),
                                                ),
                                              ),
                                            if (item.selectedColor!.hexCode != null && item.selectedColor!.hexCode!.isNotEmpty) SizedBox(width: AppTheme.space1),
                                            Text(
                                              item.selectedColor!.nameAr,
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Text(
                                      formatIQD(item.product.finalPrice),
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: AppTheme.space2),
                                    Row(
                                      children: [
                                        _QtyButton(
                                          icon: Icons.remove_rounded,
                                          onTap: () => cart.setQuantity(item.product.id, item.quantity - 1, colorId: item.selectedColor?.id),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: AppTheme.space2),
                                          child: Text('${item.quantity}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                        ),
                                        _QtyButton(
                                          icon: Icons.add_rounded,
                                          onTap: () => cart.setQuantity(item.product.id, item.quantity + 1, colorId: item.selectedColor?.id),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.delete_outline_rounded, color: AppColors.pinkDeep),
                                          onPressed: () => cart.remove(item.product.id, colorId: item.selectedColor?.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppTheme.space5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: AppColors.softShadow,
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('الإجمالي', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(
                              formatIQD(cart.totalAmount),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.gold, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        SizedBox(height: AppTheme.space4),
                        AnimatedPrimaryButton(
                          label: 'إتمام الطلب',
                          onPressed: () => context.push('/checkout'),
                          icon: Icons.check_circle_outline,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.linen,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.terracottaDark),
        ),
      ),
    );
  }
}
