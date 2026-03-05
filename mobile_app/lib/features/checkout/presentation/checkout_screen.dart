import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/features/auth/presentation/user_provider.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/widgets/animated_primary_button.dart';
import 'package:cosmatic_app/core/utils/iqd_format.dart';
import 'package:cosmatic_app/core/constants/api_constants.dart';
import 'package:cosmatic_app/core/network/api_client.dart';
import 'package:cosmatic_app/features/cart/presentation/cart_provider.dart';
import 'package:cosmatic_app/data/repositories/order_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();
  final _couponController = TextEditingController();
  final _orderRepo = OrderRepository();
  bool _loading = false;
  String? _error;
  int _discount = 0;
  String? _couponMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _validateCoupon(int subtotal) async {
    final code = _couponController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _discount = 0;
        _couponMessage = null;
      });
      return;
    }
    try {
      final res = await ApiClient().post(
        ApiConstants.couponsValidate,
        body: {'code': code, 'subtotal': subtotal},
      );
      setState(() {
        _discount = (res['discount'] as num?)?.toInt() ?? 0;
        _couponMessage = res['message'] as String?;
      });
    } catch (_) {
      setState(() {
        _discount = 0;
        _couponMessage = 'القسيمة غير صالحة';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إتمام الطلب', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
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
                    const Text('السلة فارغة'),
                    TextButton(onPressed: () => context.go('/home'), child: const Text('العودة للرئيسية')),
                  ],
                ),
              );
            }
            final subtotal = cart.totalAmount;
            final total = subtotal - _discount;
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.space4),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.space4),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                              validator: (v) => v?.trim().isEmpty ?? true ? 'مطلوب' : null,
                            ),
                            SizedBox(height: AppTheme.space3),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v?.trim().isEmpty ?? true ? 'مطلوب' : null,
                            ),
                            SizedBox(height: AppTheme.space3),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(labelText: 'عنوان التوصيل'),
                              maxLines: 2,
                              validator: (v) => v?.trim().isEmpty ?? true ? 'مطلوب' : null,
                            ),
                            SizedBox(height: AppTheme.space3),
                            TextFormField(
                              controller: _cityController,
                              decoration: const InputDecoration(labelText: 'المدينة (اختياري)'),
                            ),
                            SizedBox(height: AppTheme.space3),
                            TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)'),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.space3),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.space4),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _couponController,
                                    decoration: const InputDecoration(labelText: 'رمز القسيمة'),
                                  ),
                                ),
                                SizedBox(width: AppTheme.space2),
                                AnimatedPrimaryButton(
                                  label: 'تطبيق',
                                  onPressed: () => _validateCoupon(subtotal),
                                  fullWidth: false,
                                  height: 48,
                                ),
                              ],
                            ),
                            if (_couponMessage != null)
                              Padding(
                                padding: EdgeInsets.only(top: AppTheme.space2),
                                child: Text(
                                  _couponMessage!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _discount > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.space3),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.space4),
                        child: Column(
                          children: [
                            _SummaryRow(label: 'المجموع الفرعي', value: formatIQD(subtotal)),
                            if (_discount > 0) _SummaryRow(label: 'الخصم', value: '- ${formatIQD(_discount)}'),
                            const Divider(),
                            _SummaryRow(label: 'الإجمالي النهائي', value: formatIQD(total), bold: true),
                          ],
                        ),
                      ),
                    ),
                    if (_error != null)
                      Padding(
                        padding: EdgeInsets.only(top: AppTheme.space2),
                        child: Text(_error!, style: const TextStyle(color: Colors.red)),
                      ),
                    SizedBox(height: AppTheme.space4),
                    AnimatedPrimaryButton(
                      label: 'تأكيد الطلب',
                      onPressed: _loading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() {
                                _loading = true;
                                _error = null;
                              });
                              try {
                                final user = context.read<UserProvider>();
                                final result = await _orderRepo.placeOrder(
                                  token: user.token,
                                  customerName: _nameController.text.trim(),
                                  customerPhone: _phoneController.text.trim(),
                                  deliveryAddress: _addressController.text.trim(),
                                  city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
                                  notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                                  couponCode: _couponController.text.trim().isEmpty ? null : _couponController.text.trim(),
                                  items: cart.toOrderItems(),
                                );
                                cart.clear();
                                if (context.mounted) context.go('/order-success?order=${result.orderNumber}');
                              } catch (e) {
                                setState(() {
                                  _error = e.toString();
                                  _loading = false;
                                });
                              }
                            },
                      isLoading: _loading,
                      icon: Icons.shopping_cart_checkout,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.space1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: bold ? FontWeight.w700 : null)),
          Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.gold, fontWeight: bold ? FontWeight.w700 : null)),
        ],
      ),
    );
  }
}
