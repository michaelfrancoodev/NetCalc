import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

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
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNumber = RegExp(r'^\d$').hasMatch(widget.text) ||
        widget.text == '.' ||
        widget.text == '0';

    // Operators that get soft blue styling
    final bool isOperator = [
      '+', '-', '×', '÷',
      '(', ')', '%', '√', 'x²', '±', 'ANS',
    ].contains(widget.text);

    final bool isClear = widget.text == 'AC';
    final bool isDel = widget.text == 'DEL';
    final bool isEqual = widget.text == '=';

    Color bgColor = AppTheme.surface;
    Color labelColor = AppTheme.textDark;
    bool hasGradient = false;

    if (isEqual) {
      hasGradient = true;
      labelColor = Colors.white;
    } else if (isClear) {
      bgColor = const Color(0xFFFFF3E0); // Soft orange
      labelColor = const Color(0xFFFF9800);
    } else if (isDel) {
      bgColor = const Color(0xFFFFEBEE); // Soft red/pink
      labelColor = const Color(0xFFFF5252);
    } else if (isOperator) {
      bgColor = const Color(0xFFE3F2FD); // Soft blue
      labelColor = AppTheme.primaryBlue;
    } else {
      bgColor = AppTheme.surface;
      labelColor = AppTheme.textDark;
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
                gradient: hasGradient ? AppTheme.accentGradient : null,
                borderRadius: BorderRadius.circular(22),
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