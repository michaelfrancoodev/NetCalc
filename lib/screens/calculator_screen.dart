import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_calc_button.dart';
import '../models/history_model.dart';
import '../models/favorite_model.dart';
import '../database/local_storage.dart';
import 'history_screen.dart';
import 'unit_conversion_screen.dart';
import 'help_screen.dart';
import 'about_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'formula_screen.dart';
import 'scientific_screen.dart';
import 'finance_screen.dart';
import 'programmer_screen.dart';
import 'fraction_screen.dart';
import 'matrix_screen.dart';
import 'statistics_screen.dart';
import 'appearance_screen.dart';

class CalculatorScreen extends StatefulWidget {
  final String? initialExpression;
  const CalculatorScreen({super.key, this.initialExpression});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _input = '';
  String _result = '0';
  String _prevAns = '';
  String _angleMode = 'DEG';
  int _precision = 10;
  bool _justCalculated = false;
  bool _isFav = false;
  int _navIndex = 0;

  final ScrollController _inputScroll = ScrollController();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn));
    _fadeCtrl.value = 1.0;

    if (widget.initialExpression != null &&
        widget.initialExpression!.isNotEmpty) {
      _input = widget.initialExpression!;
      _livePreview();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _inputScroll.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _angleMode = prefs.getString('angle_mode') ?? 'DEG';
        _precision = prefs.getInt('precision') ?? 10;
      });
    } catch (_) {}
  }

  void _onTap(String val) {
    HapticFeedback.selectionClick();
    setState(() {
      switch (val) {
        case 'AC':
          _input = '';
          _result = '0';
          _justCalculated = false;
          _isFav = false;
          break;
        case 'DEL':
          if (_input.isNotEmpty) {
            const tokens = [
              'sin(', 'cos(', 'tan(', 'asin(', 'acos(', 'atan(',
              'log(', 'ln(', 'sqrt(', 'cbrt(', 'abs(', 'exp(', 'ANS'
            ];
            bool removed = false;
            for (final t in tokens) {
              if (_input.endsWith(t)) {
                _input = _input.substring(0, _input.length - t.length);
                removed = true;
                break;
              }
            }
            if (!removed) _input = _input.substring(0, _input.length - 1);
          }
          if (_input.isEmpty) _result = '0';
          _justCalculated = false;
          break;
        case '=':
          _calculate();
          break;
        case 'ANS':
          if (_prevAns.isNotEmpty) {
            _input = _justCalculated ? 'ANS' : '${_input}ANS';
            _justCalculated = false;
          }
          break;
        case '±':
          _toggleSign();
          break;
        default:
          if (_justCalculated) {
            final isOp = ['+', '-', '×', '÷', '^', '%'].contains(val);
            _input = isOp ? _result + _op(val) : _op(val);
            _justCalculated = false;
          } else {
            _input += _op(val);
          }
      }
    });
    if (_input.isNotEmpty && val != '=') _livePreview();
    _scrollEnd();
  }

  String _op(String v) {
    switch (v) {
      case '×':
        return '*';
      case '÷':
        return '/';
      case '-':
        return '-';
      case 'x²':
        return '^2';
      case 'xʸ':
        return '^';
      case '√':
        return 'sqrt(';
      case 'sin':
      case 'cos':
      case 'tan':
      case 'log':
      case 'ln':
        return '$v(';
      case 'π':
        return 'pi';
      case 'e':
        return 'e';
      case 'ABS':
        return 'abs(';
      case 'MOD':
        return '%';
      default:
        return v;
    }
  }

  void _toggleSign() {
    if (_input.isEmpty) return;
    final m = RegExp(r'(-?\d+\.?\d*)$').firstMatch(_input);
    if (m != null) {
      final n = m.group(0)!;
      final neg = n.startsWith('-') ? n.substring(1) : '-$n';
      _input = _input.substring(0, m.start) + neg;
    }
  }

  void _livePreview() {
    try {
      final s = sanitizeExpr(_input, _prevAns);
      final v = _ExprParser(s, _angleMode).evaluate();
      if (v != null && v.isFinite) {
        setState(() => _result = _fmt(v));
      }
    } catch (_) {}
  }

  void _calculate() {
    if (_input.isEmpty) return;
    try {
      final s = sanitizeExpr(_input, _prevAns);
      final v = _ExprParser(s, _angleMode).evaluate();
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
      final expr = _input;
      LocalStorage.addHistory(
          HistoryEntry(expression: expr, result: f, timestamp: DateTime.now()));
      _fadeCtrl.reset();
      setState(() {
        _result = f;
        _prevAns = f;
        _justCalculated = true;
        _isFav = LocalStorage.isFavorite(expr, f);
      });
      _fadeCtrl.forward();
    } catch (e) {
      setState(() {
        _result = 'Syntax Error';
        _justCalculated = false;
      });
    }
  }

  String _fmt(double v) {
    if (v.isInfinite) return v > 0 ? '∞' : '-∞';
    if (v.isNaN) return 'Error';
    if (v == v.truncateToDouble() && v.abs() < 1e15) {
      return v.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    String s = v.toStringAsFixed(_precision);
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return s;
  }

  void _scrollEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_inputScroll.hasClients) {
        _inputScroll.animateTo(
          _inputScroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 80),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildDisplayCard(),
            _buildScientificRows(),
            Expanded(child: _buildKeypad()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu_rounded,
              color: AppTheme.textDark, size: 26),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        const SizedBox(width: 4),
        Image.asset(
          'assets/images/splash_logo.png',
          width: 28,
          height: 28,
          errorBuilder: (c, e, s) => ShaderMask(
            shaderCallback: (b) =>
                AppTheme.accentGradient.createShader(b),
            child:
            const Icon(Icons.calculate_rounded, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'NetCalc',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark),
              ),
              TextSpan(
                text: ' Pro',
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryPurple),
              ),
            ],
          ),
        ),
        const Spacer(),
        _circleIcon(
          Icons.history_rounded,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HistoryScreen())),
          tooltip: 'History',
        ),
        _circleIcon(
          Icons.star_outline_rounded,
          () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          tooltip: 'Favorites',
        ),
      ],
    ),
  );

  Widget _circleIcon(IconData icon, VoidCallback onTap, {String tooltip = ''}) =>
      Tooltip(
        message: tooltip,
        child: Container(
          margin: const EdgeInsets.only(left: 6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: AppTheme.textDark, size: 20),
            onPressed: onTap,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ),
      );

  Widget _buildDisplayCard() => Container(
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10))
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            _chip(_angleMode, () {
              setState(() {
                _angleMode = _angleMode == 'DEG'
                    ? 'RAD'
                    : (_angleMode == 'RAD' ? 'GRAD' : 'DEG');
              });
              _livePreview();
            }),
            const SizedBox(width: 8),
            _chip('$_precision Digits', () {}),
            const Spacer(),
            // Save to Favorites — only shown after a calculation
            if (_justCalculated)
              GestureDetector(
                onTap: () async {
                  if (_isFav) return; // already saved
                  final entry = FavoriteEntry(
                    expression: _input,
                    result: _result,
                    savedAt: DateTime.now(),
                  );
                  await LocalStorage.addFavorite(entry);
                  HapticFeedback.lightImpact();
                  if (mounted) setState(() => _isFav = true);
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    _isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                    key: ValueKey(_isFav),
                    color: _isFav
                        ? const Color(0xFFFFB800)
                        : AppTheme.textGrey,
                    size: 26,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          controller: _inputScroll,
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Text(
            _input.isEmpty ? ' ' : _inputDisplay(_input),
            style: const TextStyle(
                fontSize: 18,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(height: 4),
        FadeTransition(
          opacity: _fadeAnim,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _result,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: (_result.contains('Error') ||
                    _result.contains('Invalid') ||
                    _result.contains('Division') ||
                    _result.contains('Syntax'))
                    ? AppTheme.textPink
                    : AppTheme.textDark,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _chip(String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlue)),
          if (label.contains('Digits'))
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 12, color: AppTheme.primaryBlue),
        ],
      ),
    ),
  );

  String _inputDisplay(String s) => s
      .replaceAll('*', '×')
      .replaceAll('/', '÷')
      .replaceAll('sqrt(', '√(')
      .replaceAll('ANS', 'Ans')
      .replaceAll('pi', 'π');

  Widget _buildScientificRows() => Column(
    children: [
      _sciRow(['sin', 'cos', 'tan', 'log', 'ln', '√', 'π']),
      _sciRow(['e', 'x²', 'xʸ', '%', '!', 'ABS', 'MOD']),
    ],
  );

  Widget _sciRow(List<String> items) => Container(
    height: 38,
    margin: const EdgeInsets.only(bottom: 8),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (c, i) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          elevation: 1,
          shadowColor: Colors.black12,
          child: InkWell(
            onTap: () => _onTap(items[i]),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                items[i],
                style: const TextStyle(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildKeypad() => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius:
      BorderRadius.vertical(top: Radius.circular(32)),
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -4))
      ],
    ),
    child: Column(
      children: [
        _row(['AC', 'DEL', '(', ')', '÷']),
        _row(['7', '8', '9', '×', '√']),
        _row(['4', '5', '6', '-', 'x²']),
        _row(['1', '2', '3', '+', '%']),
        _row(['±', '0', '.', '=', 'ANS']),
      ],
    ),
  );

  Widget _row(List<String> labels) =>
      Expanded(child: Row(children: labels.map((l) => _btn(l)).toList()));

  Widget _btn(String label) => GlassCalcButton(
    text: label,
    baseColor: Colors.white,
    onPressed: () => _onTap(label),
  );

  Widget _buildBottomNav() => Container(
    height: 72,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius:
      BorderRadius.vertical(top: Radius.circular(28)),
      boxShadow: [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2))
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navItem(Icons.grid_view_rounded, 'Calculator', 0),
        _navItem(Icons.swap_horiz_rounded, 'Converter', 1),
        _navItem(Icons.functions_rounded, 'Formula', 2),
        _navItem(Icons.more_horiz_rounded, 'More', 3),
      ],
    ),
  );

  Widget _navItem(IconData icon, String label, int index) {
    final bool active = _navIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _navIndex = index);
        if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const UnitConversionScreen()));
        }
        if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const FormulaScreen()));
        }
        if (index == 3) _scaffoldKey.currentState?.openDrawer();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: active
                  ? AppTheme.primaryBlue.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: active
                  ? AppTheme.primaryBlue
                  : AppTheme.textGrey.withOpacity(0.5),
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: active
                  ? AppTheme.primaryBlue
                  : AppTheme.textGrey.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() => Drawer(
    backgroundColor: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/splash_logo.png',
                  width: 32,
                  height: 32,
                  errorBuilder: (c, e, s) => const Icon(
                      Icons.calculate_rounded,
                      color: AppTheme.primaryBlue),
                ),
                const SizedBox(width: 12),
                const Text(
                  'NetCalc Pro',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textDark),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                // ── Quick access ──────────────────────────────────────
                _drawerSection('Quick Access'),
                _drawerItem(
                  Icons.history_rounded,
                  'History',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HistoryScreen())),
                ),
                _drawerItem(
                  Icons.star_outline_rounded,
                  'Favorites',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                ),
                // ── Tools ─────────────────────────────────────────────
                _drawerSection('Tools'),
                _drawerItem(
                  Icons.science_outlined,
                  'Scientific',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ScientificScreen())),
                ),
                _drawerItem(
                  Icons.account_balance_rounded,
                  'Finance',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FinanceScreen())),
                ),
                _drawerItem(
                  Icons.code_rounded,
                  'Programmer',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProgrammerScreen())),
                ),
                _drawerItem(
                  Icons.calculate_outlined,
                  'Fractions',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FractionScreen())),
                ),
                _drawerItem(
                  Icons.grid_3x3_rounded,
                  'Matrix',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const MatrixScreen())),
                ),
                _drawerItem(
                  Icons.bar_chart_rounded,
                  'Statistics',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const StatisticsScreen())),
                ),
                _drawerItem(
                  Icons.swap_horiz_rounded,
                  'Unit Converter',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UnitConversionScreen())),
                ),
                _drawerItem(
                  Icons.menu_book_outlined,
                  'Formula Library',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FormulaScreen())),
                ),
                // ── Settings ──────────────────────────────────────────
                _drawerSection('Settings'),
                _drawerItem(
                  Icons.palette_outlined,
                  'Appearance',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AppearanceScreen())),
                ),
                _drawerItem(
                  Icons.settings_outlined,
                  'Settings',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
                _drawerItem(
                  Icons.help_outline_rounded,
                  'Help & Guide',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HelpScreen())),
                ),
                _drawerItem(
                  Icons.info_outline_rounded,
                  'About',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutScreen())),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _drawerSection(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: AppTheme.textGrey,
        letterSpacing: 1.5,
      ),
    ),
  );

  Widget _drawerItem(IconData i, String l, VoidCallback t) => ListTile(
    leading: Icon(i, color: AppTheme.textGrey, size: 20),
    title: Text(l, style: const TextStyle(fontWeight: FontWeight.w500)),
    dense: true,
    onTap: () {
      Navigator.pop(context);
      t();
    },
  );
}

// ─── Expression Parser ────────────────────────────────────────────────────────

class _ExprParser {
  final String _src;
  final String _mode;
  int _pos = 0;

  _ExprParser(this._src, this._mode);

  double? evaluate() {
    if (_src.trim().isEmpty) return null;
    try {
      final result = _parseExpr();
      return result;
    } catch (_) {
      return null;
    }
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
        final d = _parsePower();
        if (d == 0) throw Exception('Division by zero');
        left /= d;
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
      return math.pow(base, _parsePower()).toDouble();
    }
    return base;
  }

  double _parseUnary() {
    _skip();
    if (_pos < _src.length && _src[_pos] == '-') {
      _pos++;
      return -_parsePower();
    }
    if (_pos < _src.length && _src[_pos] == '+') _pos++;
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skip();
    if (_pos >= _src.length) return 0;
    final ch = _src[_pos];

    if (ch == '(') {
      _pos++;
      final v = _parseExpr();
      _skip();
      if (_pos < _src.length && _src[_pos] == ')') _pos++;
      return v;
    }

    if (RegExp(r'[\d.]').hasMatch(ch)) return _parseNumber();

    if (RegExp(r'[a-zA-Z]').hasMatch(ch)) {
      final name = _parseIdent();
      _skip();
      if (_pos < _src.length && _src[_pos] == '(') {
        _pos++;
        final arg = _parseExpr();
        _skip();
        if (_pos < _src.length && _src[_pos] == ')') _pos++;
        return _applyFn(name, arg);
      }
      if (name == 'pi') return math.pi;
      if (name == 'e') return math.e;
    }

    _pos++;
    return 0;
  }

  double _parseNumber() {
    final start = _pos;
    while (_pos < _src.length && RegExp(r'[\d.eE]').hasMatch(_src[_pos])) {
      if (_src[_pos] == 'e' || _src[_pos] == 'E') {
        _pos++;
        if (_pos < _src.length &&
            (_src[_pos] == '+' || _src[_pos] == '-')) _pos++;
      } else {
        _pos++;
      }
    }
    return double.parse(_src.substring(start, _pos));
  }

  String _parseIdent() {
    final start = _pos;
    while (_pos < _src.length &&
        RegExp(r'[a-zA-Z0-9]').hasMatch(_src[_pos])) {
      _pos++;
    }
    return _src.substring(start, _pos);
  }

  void _skip() {
    while (_pos < _src.length && _src[_pos] == ' ') _pos++;
  }

  double _applyFn(String fn, double x) {
    double val = x;
    if (['sin', 'cos', 'tan'].contains(fn)) {
      if (_mode == 'DEG') {
        val = x * math.pi / 180;
      } else if (_mode == 'GRAD') {
        val = x * math.pi / 200;
      }
    }
    switch (fn) {
      case 'sin':
        return _tidy(math.sin(val));
      case 'cos':
        return _tidy(math.cos(val));
      case 'tan':
        return _tidy(math.tan(val));
      case 'asin':
        final r = math.asin(x);
        return _mode == 'DEG' ? r * 180 / math.pi : r;
      case 'acos':
        final r = math.acos(x);
        return _mode == 'DEG' ? r * 180 / math.pi : r;
      case 'atan':
        final r = math.atan(x);
        return _mode == 'DEG' ? r * 180 / math.pi : r;
      case 'sqrt':
        return math.sqrt(x);
      case 'cbrt':
        return math.pow(x.abs(), 1 / 3).toDouble() * (x < 0 ? -1 : 1);
      case 'log':
        return math.log(x) / math.ln10;
      case 'ln':
        return math.log(x);
      case 'abs':
      case 'ABS':
        return x.abs();
      case 'exp':
        return math.exp(x);
      default:
        return 0;
    }
  }

  double _tidy(double v) => v.abs() < 1e-10 ? 0 : v;
}

// ─── Utilities ────────────────────────────────────────────────────────────────

String sanitizeExpr(String raw, String prevAns) {
  String s = raw
      .replaceAll('×', '*')
      .replaceAll('÷', '/')
      .replaceAll('√(', 'sqrt(')
      .replaceAll('π', 'pi')
      .replaceAll('Ans', 'ANS');

  // Replace standalone 'e' (not part of a word) with its numeric value
  s = s.replaceAllMapped(
    RegExp(r'(?<![a-zA-Z])e(?![a-zA-Z(])'),
        (_) => '(${math.e})',
  );

  // Replace ANS with previous answer
  s = s.replaceAll('ANS', prevAns.isEmpty ? '0' : prevAns);

  // Factorial: n! → computed value using double to support large n
  s = s.replaceAllMapped(RegExp(r'(\d+)!'), (m) {
    final n = int.parse(m.group(1)!);
    if (n > 170) return 'Infinity'; // double.infinity territory
    if (n < 0) return '0';
    double f = 1;
    for (int i = 2; i <= n; i++) f *= i;
    return f.toStringAsFixed(0);
  });

  // Percentage: n% → (n/100) only when NOT used as MOD (not followed by a digit/letter/open-paren)
  s = s.replaceAllMapped(
    RegExp(r'(\d+\.?\d*)%(?![0-9a-zA-Z(])'),
        (m) => '(${m.group(1)}/100)',
  );

  // Implicit multiplication: 2( → 2*(
  s = s.replaceAllMapped(RegExp(r'(\d)\('), (m) => '${m.group(1)}*(');
  s = s.replaceAllMapped(RegExp(r'\)\('), (_) => ')*(');
  s = s.replaceAllMapped(RegExp(r'\)(\d)'), (m) => ')*${m.group(1)}');

  // Implicit multiplication before functions: 2sin → 2*sin
  s = s.replaceAllMapped(
    RegExp(
        r'(\d)(sin|cos|tan|asin|acos|atan|sqrt|cbrt|log|ln|abs|exp|pi|floor|ceil|round)'),
        (m) => '${m.group(1)}*${m.group(2)}',
  );

  // Auto-close unclosed parentheses
  final open = '('.allMatches(s).length;
  final close = ')'.allMatches(s).length;
  if (open > close) s += ')' * (open - close);

  return s;
}

/// Public wrapper for unit tests
class ExprParserForTest {
  final _ExprParser _inner;
  ExprParserForTest(String src) : _inner = _ExprParser(src, 'DEG');
  double? evaluate() => _inner.evaluate();
}

/// Evaluate a raw expression string (DEG mode, no previous answer)
double? evalFull(String raw, {String prevAns = ''}) {
  try {
    final s = sanitizeExpr(raw, prevAns);
    return _ExprParser(s, 'DEG').evaluate();
  } catch (_) {
    return null;
  }
}
