import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderNumber;

  const OrderSuccessScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.space6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                Container(
                  padding: EdgeInsets.all(AppTheme.space6),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.elevatedShadow,
                    border: Border.all(color: AppColors.glassBorder, width: 3),
                  ),
                  child: Icon(Icons.check_circle_rounded, size: 88, color: Colors.green.shade600),
                ),
                SizedBox(height: AppTheme.space6),
                Text(
                  'تم تأكيد طلبك بنجاح',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                ),
                SizedBox(height: AppTheme.space2),
                if (orderNumber.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.space4, vertical: AppTheme.space2),
                    decoration: BoxDecoration(
                      color: AppColors.parchment,
                      borderRadius: AppTheme.radiusSmall,
                    ),
                    child: Text(
                      'رقم الطلب: $orderNumber',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.terracotta, fontWeight: FontWeight.w700),
                    ),
                  ),
                SizedBox(height: AppTheme.space6),
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.go('/home'),
                      borderRadius: AppTheme.radiusMedium,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppTheme.space4),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: AppTheme.radiusMedium,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Text(
                          'العودة للرئيسية',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.space3),
                TextButton(
                  onPressed: () => context.go('/order-tracking'),
                  child: Text('تتبع الطلبات', style: TextStyle(color: AppColors.roseGold, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
