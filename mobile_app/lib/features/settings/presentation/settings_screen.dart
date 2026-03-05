import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';
import 'package:cosmatic_app/features/auth/presentation/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true);
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (b) => AppColors.accentGradient.createShader(b),
              child: Text('Rybella Iraq', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('منصة تجارة إلكترونية فاخرة لمنتجات التجميل والعناية بالبشرة.', style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.6)),
              SizedBox(height: AppTheme.space4),
              Text('الإصدار 1.0.0', style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('حسناً', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusLarge),
        title: const Text('اللغة'),
        content: Text('التطبيق متوفر حالياً باللغة العربية فقط. العربية - العراق', textAlign: TextAlign.center, style: Theme.of(ctx).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('حسناً', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
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
        child: ListView(
          padding: EdgeInsets.all(AppTheme.space4),
          children: [
            if (context.watch<UserProvider>().isLoggedIn) ...[
              _SettingsTile(icon: Icons.person_rounded, title: 'طلباتي', subtitle: context.watch<UserProvider>().user?.name, onTap: () => context.push('/my-orders')),
              _SettingsTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', onTap: () async {
                await context.read<UserProvider>().logout();
                if (context.mounted) context.pop();
              }),
            ] else ...[
              _SettingsTile(icon: Icons.login_rounded, title: 'تسجيل الدخول', onTap: () => context.push('/login')),
              _SettingsTile(icon: Icons.person_add_rounded, title: 'إنشاء حساب', onTap: () => context.push('/register')),
            ],
            _SettingsTile(icon: Icons.receipt_long_rounded, title: 'تتبع الطلبات', onTap: () => context.push('/order-tracking')),
            _SettingsTile(icon: Icons.favorite_rounded, title: 'المفضلة', onTap: () => context.push('/wishlist')),
            Container(
              margin: EdgeInsets.only(bottom: AppTheme.space2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.radiusMedium,
                boxShadow: AppColors.cardShadow,
              ),
              child: SwitchListTile(
                secondary: Icon(Icons.notifications_outlined, color: AppColors.gold),
                title: Text('الإشعارات', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('تفعيل إشعارات العروض والطلبات', style: Theme.of(context).textTheme.bodySmall),
                value: _notificationsEnabled,
                onChanged: _setNotifications,
                activeTrackColor: AppColors.goldLight,
                activeThumbColor: AppColors.gold,
                shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
              ),
            ),
            _SettingsTile(icon: Icons.language_rounded, title: 'اللغة', subtitle: 'العربية', onTap: _showLanguageDialog),
            _SettingsTile(icon: Icons.info_outline_rounded, title: 'عن التطبيق', subtitle: 'Rybella Iraq - جمالك فخامة', onTap: _showAboutDialog),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({required this.icon, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.space2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.radiusMedium,
        boxShadow: AppColors.cardShadow,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.pinkLight, borderRadius: AppTheme.radiusSmall),
          child: Icon(icon, color: AppColors.gold, size: 22),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle!, style: Theme.of(context).textTheme.bodySmall) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.radiusMedium),
      ),
    );
  }
}
