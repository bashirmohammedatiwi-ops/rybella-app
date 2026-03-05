import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/data/models/order_model.dart';
import 'package:cosmatic_app/data/repositories/order_repository.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final _repo = OrderRepository();
  final _phoneController = TextEditingController();
  List<OrderModel> _orders = [];
  bool _loading = false;
  bool _searched = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) return;
    setState(() {
      _loading = true;
      _searched = true;
    });
    try {
      final list = await _repo.trackByPhone(phone);
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
        title: const Text('تتبع الطلب'),
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
                    children: [
                      Text(
                        'أدخلي رقم هاتفك للبحث عن طلباتك',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: AppTheme.space3),
                      TextField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف',
                          hintText: '07XXXXXXXX',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: AppTheme.space3),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _search,
                          child: _loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('بحث'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_searched && !_loading) ...[
                SizedBox(height: AppTheme.space4),
                if (_orders.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppTheme.space5),
                      child: Text('لا توجد طلبات لهذا الرقم', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  )
                else
                  ..._orders.map((o) => Card(
                        margin: EdgeInsets.only(bottom: AppTheme.space3),
                        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(AppTheme.space3),
                          title: Text(o.orderNumber, style: Theme.of(context).textTheme.titleMedium),
                          subtitle: Text('${o.statusLabelAr ?? o.status} • ${formatIQD(o.total)}'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => context.push('/order-detail?number=${o.orderNumber}'),
                        ),
                      )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
