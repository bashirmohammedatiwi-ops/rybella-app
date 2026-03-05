import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)));
    _scaleController.forward();
    _pulseController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([_scaleController, _pulseController]),
            builder: (context, child) {
              return Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _scale.value * (0.98 + 0.04 * _pulseController.value),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(AppTheme.space5),
                        decoration: BoxDecoration(
                          color: AppColors.glassWhite,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.elevatedShadow,
                          border: Border.all(color: AppColors.glassBorder, width: 2),
                        ),
                        child: ShaderMask(
                          shaderCallback: (b) => AppColors.accentGradient.createShader(b),
                          child: const Icon(Icons.auto_awesome, size: 56, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: AppTheme.space5),
                      ShaderMask(
                        shaderCallback: (b) => AppColors.accentGradient.createShader(b),
                        child: Text(
                          'Rybella Iraq',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                        ),
                      ),
                      SizedBox(height: AppTheme.space2),
                      Text(
                        'جمالك أناقة',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
