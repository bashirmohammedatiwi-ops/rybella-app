import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cosmatic_app/core/theme/app_theme.dart';
import 'package:cosmatic_app/core/theme/app_colors.dart';

/// زر رئيسي متحرك - تأثيرات عند الضغط والتأثير البصري
class AnimatedPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final double? height;

  const AnimatedPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.height,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isEnabled
          ? () {
              HapticFeedback.mediumImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height ?? 54,
          decoration: BoxDecoration(
            gradient: isEnabled ? AppColors.accentGradient : null,
            color: isEnabled ? null : AppColors.stone.withValues(alpha: 0.5),
            borderRadius: AppTheme.radiusMedium,
            boxShadow: isEnabled ? AppColors.buttonGlow : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: null,
              borderRadius: AppTheme.radiusMedium,
              splashColor: Colors.white.withValues(alpha: 0.4),
              highlightColor: Colors.white.withValues(alpha: 0.2),
              child: Padding(
                padding: widget.fullWidth ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: AppTheme.space4),
                child: Center(
                  child: widget.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                          backgroundColor: Colors.white38,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: isEnabled ? Colors.white : AppColors.textMuted,
                              size: 22,
                            ),
                            SizedBox(width: AppTheme.space2),
                          ],
                          Text(
                            widget.label,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isEnabled ? Colors.white : AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                          ),
                        ],
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// زر إضافة للسلة - نسخة أصغر مع تأثير
class AnimatedAddToCartButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  const AnimatedAddToCartButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
  });

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.enabled) {
          HapticFeedback.selectionClick();
          _controller.forward();
        }
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.enabled
          ? () {
              HapticFeedback.mediumImpact();
              _controller.reverse();
              widget.onPressed?.call();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: AppTheme.space2),
          decoration: BoxDecoration(
            gradient: widget.enabled ? AppColors.accentGradient : null,
            color: widget.enabled ? null : AppColors.linen,
            borderRadius: AppTheme.radiusSmall,
            boxShadow: widget.enabled ? AppColors.softShadow : null,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: widget.enabled ? Colors.white : AppColors.textMuted,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
          ),
        ),
      ),
    );
  }
}
