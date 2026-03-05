import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/auth/presentation/user_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await context.read<UserProvider>().register(
            name: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmController.text,
          );
      if (mounted) context.go('/home');
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppTheme.space6),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('إنشاء حساب', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    SizedBox(height: AppTheme.space6),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
                      child: Padding(
                        padding: EdgeInsets.all(AppTheme.space5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'الاسم'),
                              validator: (v) => v == null || v.trim().isEmpty ? 'أدخل الاسم' : null,
                            ),
                            SizedBox(height: AppTheme.space4),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: 'رقم الهاتف *'),
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.trim().isEmpty ? 'أدخل رقم الهاتف' : null,
                            ),
                            SizedBox(height: AppTheme.space4),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'البريد (اختياري)'),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: AppTheme.space4),
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(labelText: 'كلمة المرور'),
                              obscureText: true,
                              validator: (v) => v == null || v.length < 6 ? '6 أحرف على الأقل' : null,
                            ),
                            SizedBox(height: AppTheme.space4),
                            TextFormField(
                              controller: _confirmController,
                              decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
                              obscureText: true,
                              validator: (v) => v != _passwordController.text ? 'غير متطابقة' : null,
                            ),
                            if (_error != null) ...[
                              SizedBox(height: AppTheme.space2),
                              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                            ],
                            SizedBox(height: AppTheme.space5),
                            ElevatedButton(
                              onPressed: _loading ? null : _register,
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.terracotta, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: AppTheme.space3)),
                              child: _loading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('تسجيل'),
                            ),
                            SizedBox(height: AppTheme.space3),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('لديك حساب؟ سجّل دخولك'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppTheme.space4),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
