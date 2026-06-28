import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FractionScreen extends StatefulWidget {
  const FractionScreen({super.key});

  @override
  State<FractionScreen> createState() => _FractionScreenState();
}

class _FractionScreenState extends State<FractionScreen> {
  int _num1 = 0, _den1 = 1;
  int _num2 = 0, _den2 = 1;
  String _op = '+';
  int _rNum = 0, _rDen = 1;
  String _resultDecimal = '';
  String _resultMixed = '';
  bool _hasResult = false;

  final _n1c = TextEditingController();
  final _d1c = TextEditingController();
  final _n2c = TextEditingController();
  final _d2c = TextEditingController();

  int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a == 0 ? 1 : a;
  }

  void _calculate() {
    _num1 = int.tryParse(_n1c.text) ?? 0;
    _den1 = int.tryParse(_d1c.text) ?? 1;
    _num2 = int.tryParse(_n2c.text) ?? 0;
    _den2 = int.tryParse(_d2c.text) ?? 1;
    if (_den1 == 0 || _den2 == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Denominator cannot be zero')),
      );
      return;
    }

    int rn, rd;
    switch (_op) {
      case '+':
        rn = _num1 * _den2 + _num2 * _den1;
        rd = _den1 * _den2;
        break;
      case '−':
        rn = _num1 * _den2 - _num2 * _den1;
        rd = _den1 * _den2;
        break;
      case '×':
        rn = _num1 * _num2;
        rd = _den1 * _den2;
        break;
      case '÷':
        if (_num2 == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot divide by zero')),
          );
          return;
        }
        rn = _num1 * _den2;
        rd = _den1 * _num2;
        break;
      default:
        return;
    }

    // Normalize sign
    if (rd < 0) {
      rn = -rn;
      rd = -rd;
    }

    final g = _gcd(rn.abs(), rd.abs());
    setState(() {
      _rNum = rn ~/ g;
      _rDen = rd ~/ g;
      _hasResult = true;

      if (_rDen == 0) {
        _resultMixed = 'Undefined';
        _resultDecimal = '';
        return;
      }

      final decimal = _rNum / _rDen;
      _resultDecimal = decimal.toStringAsFixed(8)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');

      if (_rDen == 1) {
        _resultMixed = '$_rNum';
      } else if (_rNum.abs() >= _rDen.abs()) {
        final whole = _rNum ~/ _rDen;
        final rem = _rNum % _rDen;
        _resultMixed = rem == 0 ? '$whole' : '$whole ${rem.abs()}/$_rDen';
      } else {
        _resultMixed = '$_rNum/$_rDen';
      }
    });
  }

  @override
  void dispose() {
    _n1c.dispose();
    _d1c.dispose();
    _n2c.dispose();
    _d2c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Fraction Calculator'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _fractionInput('First Fraction', _n1c, _d1c),
              const SizedBox(height: 16),
              _operatorRow(),
              const SizedBox(height: 16),
              _fractionInput('Second Fraction', _n2c, _d2c),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: TextButton(
                    onPressed: _calculate,
                    child: const Text('Calculate',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_hasResult) _resultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fractionInput(
      String label, TextEditingController nc, TextEditingController dc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 12)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textGrey)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _numField('Numerator', nc)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('/',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textGrey)),
              ),
              Expanded(child: _numField('Denominator', dc)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _numField(String hint, TextEditingController c) => TextField(
        controller: c,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: false),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
          filled: true,
          fillColor: AppTheme.surface,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      );

  Widget _operatorRow() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['+', '−', '×', '÷'].map((op) {
          final sel = _op == op;
          return GestureDetector(
            onTap: () => setState(() => _op = op),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: sel ? AppTheme.accentGradient : null,
                color: sel ? null : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 8)
                ],
              ),
              child: Center(
                child: Text(op,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: sel ? Colors.white : AppTheme.textDark)),
              ),
            ),
          );
        }).toList(),
      );

  Widget _resultCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04), blurRadius: 12)
          ],
        ),
        child: Column(
          children: [
            const Text('Result',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textGrey)),
            const SizedBox(height: 12),
            // Fraction display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_rDen != 1)
                  Column(
                    children: [
                      Text('$_rNum',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark)),
                      Container(height: 2, width: 60, color: AppTheme.textDark),
                      Text('$_rDen',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textDark)),
                    ],
                  )
                else
                  Text('$_rNum',
                      style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textDark)),
              ],
            ),
            const SizedBox(height: 8),
            Text('= $_resultMixed',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue)),
            const SizedBox(height: 4),
            Text('= $_resultDecimal',
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textGrey)),
          ],
        ),
      );
}
