import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../theme/settings_manager.dart';
import '../widgets/glass_calc_button.dart';
import '../database/local_storage.dart';
import '../models/history_model.dart';

class ScientificScreen extends StatefulWidget {
  const ScientificScreen({super.key});

  @override
  State<ScientificScreen> createState() => _ScientificScreenState();
}

class _ScientificScreenState extends State<ScientificScreen>
    with SingleTickerProviderStateMixin {
  String _input = '';
  String _result = '0';
  String _prevAns = '';
  String _angleMode = 'DEG';
  bool _isSecond = false;
  bool _justCalculated = false;
  final int _precision = 10;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));
    _fadeCtrl.value = 1.0;
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  List<String> get _row1 => _isSecond
      ? ['asin(', 'acos(', 'atan(', 'sinh(', 'cosh(', 'tanh(']
      : ['sin(', 'cos(', 'tan(', 'sinh(', 'cosh(', 'tanh('];

  List<String> get _row2 => _isSecond
      ? ['log₂(', 'log(', 'ln(', '10^', 'e^', 'RND']
      : ['log(', 'ln(', 'log₂(', '10^', 'e^', 'EXP'];

  List<String> get _row3 => ['x²', 'x³', 'xʸ', '√', '∛', 'ʸ√'];

  List<String> get _row4 => ['π', 'e', 'φ', '|x|', 'n!', 'MOD'];

  void _onTap(String val) {
    HapticFeedback.selectionClick();
    setState(() {
      if (val == '2nd') {
        _isSecond = !_isSecond;
        return;
      }
      if (val == 'AC') {
        _input = '';
        _result = '0';
        _justCalculated = false;
        return;
      }
      if (val == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
        }
        if (_input.isEmpty) _result = '0';
        _justCalculated = false;
        return;
      }
      if (val == '=') {
        _calculate();
        return;
      }

      final s = _sciOp(val);
      if (_justCalculated) {
        final isOp = ['+', '-', '*', '/', '^', '%'].contains(s);
        _input = isOp ? _result + s : s;
        _justCalculated = false;
      } else {
        _input += s;
      }
    });
    if (_input.isNotEmpty && val != '=') _livePreview();
  }

  String _sciOp(String v) {
    switch (v) {
      case '×': return '*';
      case '÷': return '/';
      case '−': return '-';
      case 'x²': return '^2';
      case 'x³': return '^3';
      case 'xʸ': return '^';
      case '√':  return 'sqrt(';
      case '∛':  return 'cbrt(';
      case 'ʸ√': return '^(1/';
      case '10^': return '10^';
      case 'e^': return 'e^';
      case 'EXP': return 'e';
      case 'π':  return 'pi';
      case 'e':  return 'e';
      case 'φ':  return '1.6180339887';
      case '|x|': return 'abs(';
      case 'n!':  return '!';
      case 'MOD': return '%';
      case 'log₂(': return 'log2(';
      case 'RND': return '${math.Random().nextDouble()}';
      default: return v;
    }
  }

  void _livePreview() {
    try {
      final s = _sanitize(_input, _prevAns);
      final v = _SciParser(s, _angleMode).evaluate();
      if (v != null && v.isFinite) setState(() => _result = _fmt(v));
    } catch (_) {}
  }

  void _calculate() {
    if (_input.isEmpty) return;
    try {
      final s = _sanitize(_input, _prevAns);
      final v = _SciParser(s, _angleMode).evaluate();
      if (v == null) {
        setState(() => _result = 'Invalid Expression');
        return;
      }
      if (v.isNaN) {
        setState(() => _result = 'Error');
        return;
      }
      if (v.isInfinite) {
        setState(() => _result = 'Division by Zero');
        return;
      }
      final f = _fmt(v);
      LocalStorage.addHistory(
          HistoryEntry(expression: _input, result: f, timestamp: DateTime.now()));
      _fadeCtrl.reset();
      setState(() {
        _result = f;
        _prevAns = f;
        _justCalculated = true;
      });
      _fadeCtrl.forward();
    } catch (_) {
      setState(() {
        _result = 'Syntax Error';
        _justCalculated = false;
      });
    }
  }

  String _sanitize(String expr, String ans) {
    String s = expr
        .replaceAll('ANS', ans.isEmpty ? '0' : ans)
        .replaceAll('pi', '3.141592653589793')
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-');
    // Factorial: n! → computed value
    s = s.replaceAllMapped(RegExp(r'(\d+)!'), (m) {
      final n = int.parse(m.group(1)!);
      if (n < 0) return '0';
      if (n > 170) return '(1/0)';
      double f = 1;
      for (int i = 2; i <= n; i++) {
        f *= i;
      }
      return f.toStringAsFixed(0);
    });
    // Auto-close unclosed parentheses
    final open  = '('.allMatches(s).length;
    final close = ')'.allMatches(s).length;
    if (open > close) s += ')' * (open - close);
    return s;
  }

  String _fmt(double v) {
    return SettingsManager().formatNumber(v);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textDark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Scientific'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _angleMode = _angleMode == 'DEG'
                  ? 'RAD'
                  : (_angleMode == 'RAD' ? 'GRAD' : 'DEG');
            }),
            child: Text(_angleMode,
                style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildDisplay(cardColor, textColor),
            const SizedBox(height: 4),
            _sciRowWidget(_row1, cardColor),
            const SizedBox(height: 4),
            _sciRowWidget(_row2, cardColor),
            const SizedBox(height: 4),
            _sciRowWidget(_row3, cardColor),
            const SizedBox(height: 4),
            _sciRowWidget(_row4, cardColor),
            const SizedBox(height: 4),
            Expanded(child: _buildKeypad(cardColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplay(Color cardColor, Color textColor) => Container(
        height: 150,
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 8))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_input.isEmpty ? ' ' : _input,
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textGrey),
                overflow: TextOverflow.ellipsis),
            const Spacer(),
            FadeTransition(
              opacity: _fadeAnim,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(_result,
                    style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        color: _result.contains('Error') ||
                                _result.contains('Syntax') ||
                                _result.contains('Invalid')
                            ? AppTheme.textPink
                            : textColor)),
              ),
            ),
          ],
        ),
      );

  Widget _sciRowWidget(List<String> items, Color cardColor) => SizedBox(
        height: 34,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
                elevation: 1,
                shadowColor: Colors.black12,
                child: InkWell(
                  onTap: () => _onTap(item),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    child: Text(item,
                        style: const TextStyle(
                            color: AppTheme.primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );

  Widget _buildKeypad(Color cardColor) => Container(
        margin: const EdgeInsets.only(top: 4),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
          ],
        ),
        child: Column(
          children: [
            _row(['2nd', 'AC', 'DEL', '(', ')']),
            _row(['7', '8', '9', '÷', '%']),
            _row(['4', '5', '6', '×', 'π']),
            _row(['1', '2', '3', '−', 'e']),
            _row(['±', '0', '.', '+', '=']),
          ],
        ),
      );

  Widget _row(List<String> labels) => Expanded(
        child: Row(
          children: labels
              .map((l) => GlassCalcButton(
                    text: l,
                    baseColor: Colors.white,
                    onPressed: () => _onTap(l),
                  ))
              .toList(),
        ),
      );
}

// ── Scientific Expression Parser ──────────────────────────────────────────────
class _SciParser {
  final String _src;
  final String _mode;
  int _pos = 0;

  _SciParser(this._src, this._mode);

  double? evaluate() {
    if (_src.trim().isEmpty) return null;
    try {
      final result = _parseExpr();
      return result;
    } catch (_) {
      return null;
    }
  }

  double _toRad(double v) {
    if (_mode == 'RAD') return v;
    if (_mode == 'GRAD') return v * math.pi / 200;
    return v * math.pi / 180;
  }

  double _parseExpr() {
    double left = _parseTerm();
    while (true) {
      _skip();
      if (_pos < _src.length && _src[_pos] == '+') {
        _pos++;
        left += _parseTerm();
      } else if (_pos < _src.length && _src[_pos] == '-') {
        _pos++;
        left -= _parseTerm();
      } else {
        break;
      }
    }
    return left;
  }

  double _parseTerm() {
    double left = _parsePower();
    while (true) {
      _skip();
      if (_pos < _src.length && _src[_pos] == '*') {
        _pos++;
        left *= _parsePower();
      } else if (_pos < _src.length && _src[_pos] == '/') {
        _pos++;
        final r = _parsePower();
        left = r == 0 ? double.infinity : left / r;
      } else if (_pos < _src.length && _src[_pos] == '%') {
        _pos++;
        left %= _parsePower();
      } else {
        break;
      }
    }
    return left;
  }

  double _parsePower() {
    double base = _parseUnary();
    _skip();
    if (_pos < _src.length && _src[_pos] == '^') {
      _pos++;
      final exp = _parsePower();
      return math.pow(base, exp).toDouble();
    }
    if (_pos < _src.length && _src[_pos] == '!') {
      _pos++;
      int n = base.toInt();
      double f = 1;
      for (int i = 2; i <= n; i++) {
        f *= i;
      }
      return f;
    }
    return base;
  }

  double _parseUnary() {
    _skip();
    if (_pos < _src.length && _src[_pos] == '-') {
      _pos++;
      return -_parsePrimary();
    }
    if (_pos < _src.length && _src[_pos] == '+') {
      _pos++;
    }
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skip();
    if (_pos >= _src.length) return 0;

    // Parentheses
    if (_src[_pos] == '(') {
      _pos++;
      final v = _parseExpr();
      if (_pos < _src.length && _src[_pos] == ')') _pos++;
      return v;
    }

    // Functions
    final funcs = ['asin', 'acos', 'atan', 'sinh', 'cosh', 'tanh',
        'sin', 'cos', 'tan', 'sqrt', 'cbrt', 'abs', 'log2', 'log', 'ln', 'exp'];
    for (final fn in funcs) {
      if (_src.startsWith(fn, _pos)) {
        _pos += fn.length;
        if (_pos < _src.length && _src[_pos] == '(') {
          _pos++;
          final arg = _parseExpr();
          if (_pos < _src.length && _src[_pos] == ')') _pos++;
          return _applyFn(fn, arg);
        }
      }
    }

    // Constants
    if (_src.startsWith('3.141592653589793', _pos)) {
      _pos += 17;
      return math.pi;
    }
    if (_src.startsWith('1.6180339887', _pos)) {
      _pos += 12;
      return 1.6180339887;
    }
    if (_pos < _src.length && _src[_pos] == 'e') {
      _pos++;
      return math.e;
    }

    // Number
    return _parseNumber();
  }

  double _applyFn(String fn, double arg) {
    switch (fn) {
      case 'sin':  return math.sin(_toRad(arg));
      case 'cos':  return math.cos(_toRad(arg));
      case 'tan':  return math.tan(_toRad(arg));
      case 'asin': return _mode == 'RAD' ? math.asin(arg) : math.asin(arg) * 180 / math.pi;
      case 'acos': return _mode == 'RAD' ? math.acos(arg) : math.acos(arg) * 180 / math.pi;
      case 'atan': return _mode == 'RAD' ? math.atan(arg) : math.atan(arg) * 180 / math.pi;
      case 'sinh': return (math.exp(arg) - math.exp(-arg)) / 2;
      case 'cosh': return (math.exp(arg) + math.exp(-arg)) / 2;
      case 'tanh': return (math.exp(2 * arg) - 1) / (math.exp(2 * arg) + 1);
      case 'sqrt': return math.sqrt(arg);
      case 'cbrt': return arg < 0 ? -math.pow(-arg, 1/3).toDouble() : math.pow(arg, 1/3).toDouble();
      case 'abs':  return arg.abs();
      case 'log':  return math.log(arg) / math.ln10;
      case 'log2': return math.log(arg) / math.log(2);
      case 'ln':   return math.log(arg);
      case 'exp':  return math.exp(arg);
      default:     return arg;
    }
  }

  double _parseNumber() {
    _skip();
    int start = _pos;
    while (_pos < _src.length && (_src[_pos] == '.' || (_src[_pos].codeUnitAt(0) >= 48 && _src[_pos].codeUnitAt(0) <= 57))) {
      _pos++;
    }
    if (_pos == start) return 0;
    return double.tryParse(_src.substring(start, _pos)) ?? 0;
  }

  void _skip() {
    while (_pos < _src.length && _src[_pos] == ' ') {
      _pos++;
    }
  }
}
