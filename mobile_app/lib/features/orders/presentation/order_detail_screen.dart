import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/data/models/order_model.dart';
import 'package:cosmatic_app/data/repositories/order_repository.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderNumber;

  const OrderDetailScreen({super.key, required this.orderNumber});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _repo = OrderRepository();
  OrderDetailModel? _order;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.orderNumber.isNotEmpty) {
      _load();
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final order = await _repo.getByOrderNumber(widget.orderNumber);
      setState(() {
        _order = order;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _error = 'الطلب غير موجود';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
          child: Center(child: CircularProgressIndicator(color: AppColors.roseGold)),
        ),
      );
    }
    if (_error != null || _order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الطلب')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? 'الطلب غير موجود'),
              TextButton(onPressed: () => context.pop(), child: const Text('رجوع')),
            ],
          ),
        ),
      );
    }
    final o = _order!;
    return Scaffold(
      appBar: AppBar(
        title: Text(o.orderNumber),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_forward_ios), onPressed: () => context.pop()),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('الحالة: ${o.statusLabelAr ?? o.status}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.gold)),
                      SizedBox(height: AppTheme.space2),
                      Text('العميل: ${o.customerName}'),
                      Text('الهاتف: ${o.customerPhone}'),
                      Text('العنوان: ${o.deliveryAddress}'),
                      if (o.city != null && o.city!.isNotEmpty) Text('المدينة: ${o.city}'),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                child: Padding(
                  padding: EdgeInsets.all(AppTheme.space4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المنتجات', style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: AppTheme.space2),
                      ...o.items.map((i) => Padding(
                            padding: EdgeInsets.symmetric(vertical: AppTheme.space1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${i.productNameAr} x ${i.quantity}'),
                                      if (i.variantDisplay != null && i.variantDisplay!.isNotEmpty)
                                        Text(i.variantDisplay!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                Text(formatIQD(i.total)),
                              ],
                            ),
                          )),
                      Divider(height: AppTheme.space4),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('المجموع الفرعي'), Text(formatIQD(o.subtotal))]),
                      if (o.discount > 0) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('الخصم'), Text('- ${formatIQD(o.discount)}')]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('الإجمالي', style: Theme.of(context).textTheme.titleMedium), Text(formatIQD(o.total), style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.gold))]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
