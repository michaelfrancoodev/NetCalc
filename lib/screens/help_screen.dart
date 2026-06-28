import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _items = [
    {'q': 'Basic arithmetic', 'a': 'Use +, -, ×, ÷ buttons for addition, subtraction, multiplication, and division.'},
    {'q': 'How to use sin / cos / tan', 'a': 'Tap sin, cos, or tan then enter the angle in degrees. Example: sin(30) = 0.5, cos(60) = 0.5, tan(45) = 1.'},
    {'q': 'Inverse trig (asin / acos / atan)', 'a': 'Returns the angle in degrees. Example: asin(1) = 90, acos(0) = 90, atan(1) = 45.'},
    {'q': 'Logarithm (log / ln)', 'a': 'log = log base 10. ln = natural logarithm (base e). Example: log(100) = 2, log(10) = 1, ln(e) = 1.'},
    {'q': 'Square root (√)', 'a': 'Tap √ then enter the number. Example: √(16) = 4, √(2) ≈ 1.4142. Negative inputs return an error.'},
    {'q': 'Cube root (∛)', 'a': 'Use cbrt(). Works on negative numbers too. Example: cbrt(27) = 3, cbrt(-8) = -2.'},
    {'q': 'Power / Exponent (^)', 'a': 'Use ^ for any power. The ^ operator is right-associative, which is mathematically standard: 2^3^2 = 2^(3^2) = 512, not 64. Example: 5^2 = 25, 4^0.5 = 2.'},
    {'q': 'Negative powers', 'a': '-2^2 = -4 (standard convention: unary minus applies after the power). Use (-2)^2 = 4 if you want to square a negative base.'},
    {'q': 'Factorial (x!)', 'a': 'Enter the number first, then tap x!. Supports integers 0–20. Example: 5! = 120, 0! = 1.'},
    {'q': 'Parentheses', 'a': 'Use ( and ) to group expressions. Unclosed brackets are automatically closed when you press =. Example: (2+3)×4 = 20.'},
    {'q': 'Percentage (%)', 'a': 'Context-aware, just like Android and Casio calculators:\n• Standalone: 20% = 0.2\n• After + or −: 500+20% = 600 (adds 20% of 500)\n• After + or −: 200−10% = 180 (subtracts 10% of 200)\n• After × or ÷: 500×20% = 100 (multiplies by 20/100)'},
    {'q': 'ANS button', 'a': 'ANS inserts the last calculated result into the current expression. Useful for chaining calculations.'},
    {'q': '1/x (Reciprocal)', 'a': 'Computes 1 divided by the current expression. Example: 1/x when input is 4 gives 0.25.'},
    {'q': 'x² (Square)', 'a': 'Appends ^2 to square the last number or expression. Example: 7x² = 49.'},
    {'q': '+/- (Negate)', 'a': 'Toggles the sign of the last number in the expression.'},
    {'q': 'DEL button', 'a': 'Deletes the last character or full token (e.g. "sin(" is deleted in one tap).'},
    {'q': 'AC button', 'a': 'Clears the entire expression and resets to zero.'},
    {'q': 'Live preview', 'a': 'The result updates in real-time as you type, whenever the expression is valid so far.'},
    {'q': 'Implicit multiplication', 'a': 'You can omit × in common cases. Examples: 2sin(30) = 1, 3pi ≈ 9.42, 2(3+1) = 8.'},
    {'q': 'Favorites (★)', 'a': 'After calculating, tap the star icon to save the expression to Favorites. Access saved entries from the side menu.'},
    {'q': 'Side menu', 'a': 'Tap the ☰ icon at the top-right to open the menu. It slides in from the right. Access History, Saved Favorites, Unit Converter, Settings, and Legal Information.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textWhite, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Help & Guide',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textWhite)),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(14),
                  itemCount: _items.length,
                  itemBuilder: (ctx, i) {
                    final item = _items[i];
                    return _HelpCard(
                        question: item['q']!, answer: item['a']!);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpCard extends StatefulWidget {
  final String question;
  final String answer;
  const _HelpCard({required this.question, required this.answer});

  @override
  State<_HelpCard> createState() => _HelpCardState();
}

class _HelpCardState extends State<_HelpCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? AppTheme.neonCyan.withOpacity(0.2)
              : Colors.white.withOpacity(0.07),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.question,
                        style: TextStyle(
                            color: _expanded
                                ? AppTheme.neonCyan
                                : AppTheme.textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textDim,
                    size: 20,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(widget.answer,
                    style: const TextStyle(
                        color: AppTheme.textDim,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
