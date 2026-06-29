import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../theme/settings_manager.dart';

class GlassCalcButton extends StatefulWidget {
  final String text;
  final Color baseColor;
  final VoidCallback onPressed;
  final int flex;
  final bool isAccent;
  final Widget? customContent;

  const GlassCalcButton({
    super.key,
    required this.text,
    required this.baseColor,
    required this.onPressed,
    this.flex = 1,
    this.isAccent = false,
    this.customContent,
  });

  @override
  State<GlassCalcButton> createState() => _GlassCalcButtonState();
}

class _GlassCalcButtonState extends State<GlassCalcButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 60),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (SettingsManager().haptic) {
      HapticFeedback.lightImpact();
    }
    // TODO: Implement sound if SettingsManager().sound is true
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final manager = SettingsManager();
    final Color accent = manager.accentColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Operators that get soft blue styling
    final bool isOperator = [
      '+', '-', '×', '÷',
      '(', ')', '%', '√', 'x²', '±', 'ANS',
    ].contains(widget.text);

    final bool isClear = widget.text == 'AC';
    final bool isDel = widget.text == 'DEL';
    final bool isEqual = widget.text == '=';

    Color bgColor = isDark ? const Color(0xFF21262D) : AppTheme.surface;
    Color labelColor = isDark ? Colors.white : AppTheme.textDark;
    bool hasGradient = false;

    if (isEqual) {
      hasGradient = true;
      labelColor = Colors.white;
    } else if (isClear) {
      bgColor = isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0);
      labelColor = const Color(0xFFFF9800);
    } else if (isDel) {
      bgColor = isDark ? const Color(0xFF311B1B) : const Color(0xFFFFEBEE);
      labelColor = const Color(0xFFFF5252);
    } else if (isOperator) {
      bgColor = accent.withOpacity(isDark ? 0.2 : 0.1);
      labelColor = accent;
    }

    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _controller.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _controller.reverse();
            _handleTap();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _controller.reverse();
          },
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: hasGradient
                    ? null
                    : (_isPressed ? bgColor.withOpacity(0.8) : bgColor),
                gradient: hasGradient ? LinearGradient(
                  colors: [accent, accent.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) : null,
                borderRadius: manager.buttonBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: widget.customContent ??
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: _fontSize(widget.text),
                        fontWeight:
                        isEqual ? FontWeight.w800 : FontWeight.w600,
                        color: labelColor,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _fontSize(String text) {
    if (text.length == 1) return 24.0;
    if (text.length == 2) return 18.0;
    return 15.0;
  }
}
