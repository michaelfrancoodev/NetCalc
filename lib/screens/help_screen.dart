import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> _items = [
    {'q': 'Basic arithmetic', 'a': 'Use +, -, ×, ÷ buttons for addition, subtraction, multiplication, and division.'},
    {'q': 'How to use sin / cos / tan', 'a': 'Tap sin, cos, or tan then enter the angle. The angle mode (DEG/RAD/GRAD) is shown in the display chip and can be toggled. Example: sin(30) = 0.5 in DEG mode.'},
    {'q': 'Inverse trig (asin / acos / atan)', 'a': 'Returns the angle in the current mode. Example: asin(1) = 90 in DEG, acos(0) = 90, atan(1) = 45.'},
    {'q': 'Logarithm (log / ln)', 'a': 'log = log base 10. ln = natural logarithm (base e). Example: log(100) = 2, ln(e) = 1.'},
    {'q': 'Square root (√)', 'a': 'Tap √ then enter the number. Example: √(16) = 4. Negative inputs return an error.'},
    {'q': 'Power / Exponent (^)', 'a': 'Use ^ for any power. Right-associative: 2^3^2 = 2^9 = 512. Example: 5^2 = 25.'},
    {'q': 'Factorial (!)', 'a': 'Enter a number then tap !. Supports integers 0–20. Example: 5! = 120, 0! = 1.'},
    {'q': 'Absolute value (ABS)', 'a': 'Returns the non-negative value. Tap ABS and enter the number. Example: abs(-7) = 7.'},
    {'q': 'Modulo (MOD)', 'a': 'Returns the remainder of division. Example: 10 MOD 3 = 1, 17 MOD 5 = 2.'},
    {'q': 'Parentheses', 'a': 'Use ( and ) to group expressions. Unclosed brackets are auto-closed when you press =. Example: (2+3)×4 = 20.'},
    {'q': 'Percentage (%)', 'a': 'After a standalone number: 20% = 0.2. After + or −: 500+20% = 600. After × or ÷: 500×20% = 100. Used between two numbers as MOD: 10%3 = 1.'},
    {'q': 'ANS button', 'a': 'ANS inserts the last calculated result into the current expression for chaining calculations.'},
    {'q': 'x² (Square)', 'a': 'Appends ^2 to square the last number. Example: 7x² = 49.'},
    {'q': '+/- (Negate)', 'a': 'Toggles the sign of the last number in the expression.'},
    {'q': 'DEL button', 'a': 'Deletes the last character or full function token (e.g. "sin(" is deleted in one tap).'},
    {'q': 'AC button', 'a': 'Clears the entire expression and resets the result to zero.'},
    {'q': 'Live preview', 'a': 'The result updates in real-time as you type whenever the expression is valid.'},
    {'q': 'Implicit multiplication', 'a': 'You can omit × in common cases: 2sin(30) = 1, 3pi ≈ 9.42, 2(3+1) = 8.'},
    {'q': 'History', 'a': 'Every successful calculation is saved automatically. Access it from the History button in the top bar or the side drawer.'},
    {'q': 'Favorites (★)', 'a': 'Tap the star in the result screen to save an expression. Access saved entries from the Favorites item in the side drawer.'},
    {'q': 'Scientific Calculator', 'a': 'Access via the drawer for advanced functions: trig, hyperbolic, log₂, RND, φ, and more, with DEG/RAD/GRAD mode.'},
    {'q': 'Finance Tools', 'a': 'Access via the drawer. Includes Loan EMI, Compound Interest, VAT, Discount, Profit/Loss, Mortgage, SIP, ROI, and more.'},
    {'q': 'Unit Converter', 'a': 'Access from the bottom nav or drawer. Converts Length, Weight, Temperature, Volume, Speed, Area, Data, Time, Pressure, and Energy.'},
    {'q': 'Formula Library', 'a': 'Access via the Formula tab in the bottom nav or the drawer. Browse and search Math, Physics, Chemistry, and Geometry formulas.'},
    {'q': 'Side drawer (☰)', 'a': 'Tap the ☰ icon at the top-left to open the menu. Contains all tools: Scientific, Finance, Programmer, Fractions, Matrix, Statistics, Converter, Formula Library, Settings, Help, and About.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
                          color: AppTheme.textDark, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Help & Guide',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark)),
                  ],
                ),
              ),
              const Divider(color: Colors.black12, height: 1),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? AppTheme.primaryBlue.withOpacity(0.25)
              : Colors.black.withOpacity(0.06),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
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
                                ? AppTheme.primaryBlue
                                : AppTheme.textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textGrey,
                    size: 20,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 10),
                Text(widget.answer,
                    style: const TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 13,
                        height: 1.6)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
