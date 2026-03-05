import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/data/models/order_model.dart';
import 'package:cosmatic_app/data/repositories/order_repository.dart';
import 'package:cosmatic_app/features/auth/presentation/user_provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final _repo = OrderRepository();
  List<OrderModel> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final token = context.read<UserProvider>().token;
    if (token == null || token.isEmpty) return;
    setState(() => _loading = true);
    try {
      final list = await _repo.getMyOrders(token);
      setState(() {
        _orders = list;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _orders = [];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلباتي', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
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
        child: _loading
            ? Center(child: CircularProgressIndicator(color: AppColors.terracotta))
            : _orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                        SizedBox(height: AppTheme.space4),
                        Text('لا توجد طلبات', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView.builder(
                      padding: EdgeInsets.all(AppTheme.space4),
                      itemCount: _orders.length,
                      itemBuilder: (_, i) {
                        final o = _orders[i];
                        return Card(
                          margin: EdgeInsets.only(bottom: AppTheme.space3),
                          shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(AppTheme.space4),
                            title: Text(o.orderNumber, style: const TextStyle(fontWeight: FontWeight.w700)),
                            subtitle: Text('${o.statusLabelAr ?? o.status} • ${formatIQD(o.total)}'),
                            trailing: const Icon(Icons.chevron_left),
                            onTap: () => context.push('/order-detail?number=${o.orderNumber}'),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
