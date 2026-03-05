import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'مرحبا بك في Rybella Iraq',
      subtitle: 'عالم من التجميل الفاخر بين يديك. منتجات مختارة بعناية لجمالك.',
      icon: Icons.spa_rounded,
      gradient: [AppColors.linen, AppColors.blush],
    ),
    OnboardingPage(
      title: 'تسوقي بكل أريحية',
      subtitle: 'تصفحي المنتجات، أضيفي للمفضلة، واطلبي بسهولة مع الدفع عند الاستلام.',
      icon: Icons.shopping_bag_rounded,
      gradient: [AppColors.pearl, AppColors.dustyRose],
    ),
    OnboardingPage(
      title: 'ابدئي رحلتك',
      subtitle: 'اكتشفي العروض المميزة وابدئي التسوق الآن.',
      icon: Icons.auto_awesome,
      gradient: [AppColors.mauveLight, AppColors.blush],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) {
                    final p = _pages[i];
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppTheme.space6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: p.gradient),
                              shape: BoxShape.circle,
                              boxShadow: AppColors.elevatedShadow,
                              border: Border.all(color: AppColors.glassBorder, width: 3),
                            ),
                            child: Icon(p.icon, size: 80, color: AppColors.roseGoldDark),
                          ),
                          SizedBox(height: AppTheme.space6),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  height: 1.3,
                                ),
                          ),
                          SizedBox(height: AppTheme.space4),
                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.7,
                                ),
                          ),
                        ],
                      ),
                    ),
                    ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _current == i ? 28 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: _current == i ? AppColors.accentGradient : null,
                      color: _current == i ? null : AppColors.mauve.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
              SizedBox(height: AppTheme.space5),
              Padding(
                padding: EdgeInsets.all(AppTheme.space5),
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_current < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/home');
                        }
                      },
                      borderRadius: AppTheme.radiusMedium,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: AppTheme.space4),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                          borderRadius: AppTheme.radiusMedium,
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Text(
                          _current < _pages.length - 1 ? 'التالي' : 'ابدئي التسوق',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
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

class OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.gradient = const [AppColors.linen, AppColors.coral],
  });
}
