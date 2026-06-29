import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'app_theme.dart';

class SettingsManager extends ChangeNotifier {
  static final SettingsManager _instance = SettingsManager._internal();
  factory SettingsManager() => _instance;
  SettingsManager._internal();

  // Appearance
  int _accentIndex = 0;
  String _buttonShape = 'Rounded';
  ThemeMode _themeMode = ThemeMode.system;

  // Calculator logic
  String _angleMode = 'DEG';
  int _precision = 10;
  String _numberFormat = 'US (1,000.00)';

  // Feedback
  bool _haptic = true;
  bool _sound = false;

  int get accentIndex => _accentIndex;
  String get buttonShape => _buttonShape;
  ThemeMode get themeMode => _themeMode;
  String get angleMode => _angleMode;
  int get precision => _precision;
  String get numberFormat => _numberFormat;
  bool get haptic => _haptic;
  bool get sound => _sound;

  Color get accentColor {
    final List<Color> accents = const [
      AppTheme.primaryBlue,
      AppTheme.primaryPurple,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.primaryPink,
      Color(0xFFFF3B30),
    ];
    if (_accentIndex >= 0 && _accentIndex < accents.length) {
      return accents[_accentIndex];
    }
    return AppTheme.primaryBlue;
  }

  BorderRadius get buttonBorderRadius {
    switch (_buttonShape) {
      case 'Square': return BorderRadius.circular(4);
      case 'Pill':   return BorderRadius.circular(30);
      default:       return BorderRadius.circular(22);
    }
  }

  Future<void> init() async {
    final p = await SharedPreferences.getInstance();
    _accentIndex = p.getInt('accent_index') ?? 0;
    _buttonShape = p.getString('button_shape') ?? 'Rounded';
    
    final tm = p.getString('theme_mode') ?? 'system';
    _themeMode = tm == 'light' ? ThemeMode.light : (tm == 'dark' ? ThemeMode.dark : ThemeMode.system);

    _angleMode = p.getString('angle_mode') ?? 'DEG';
    _precision = p.getInt('precision') ?? 10;
    _haptic = p.getBool('haptic') ?? true;
    _sound = p.getBool('sound') ?? false;
    _numberFormat = p.getString('number_format') ?? 'US (1,000.00)';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    String m = mode == ThemeMode.light ? 'light' : (mode == ThemeMode.dark ? 'dark' : 'system');
    await p.setString('theme_mode', m);
  }

  Future<void> setAccentIndex(int i) async {
    _accentIndex = i;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('accent_index', i);
  }

  Future<void> setButtonShape(String s) async {
    _buttonShape = s;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('button_shape', s);
  }

  Future<void> setHaptic(bool v) async {
    _haptic = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('haptic', v);
  }

  Future<void> setPrecision(int v) async {
    _precision = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setInt('precision', v);
  }

  Future<void> setAngleMode(String m) async {
    _angleMode = m;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('angle_mode', m);
  }

  Future<void> setNumberFormat(String f) async {
    _numberFormat = f;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setString('number_format', f);
  }

  Future<void> setSound(bool v) async {
    _sound = v;
    notifyListeners();
    final p = await SharedPreferences.getInstance();
    await p.setBool('sound', v);
  }

  String formatNumber(double v) {
    if (v.isInfinite) return v > 0 ? '∞' : '-∞';
    if (v.isNaN) return 'Error';

    // Use intl for number formatting based on locale preference
    NumberFormat nf;
    if (_numberFormat.contains('EU')) {
      nf = NumberFormat.decimalPattern('de_DE');
    } else if (_numberFormat.contains('IN')) {
      nf = NumberFormat.decimalPattern('en_IN');
    } else {
      nf = NumberFormat.decimalPattern('en_US');
    }

    // Handle scientific notation for extremely large/small numbers
    if (v.abs() >= 1e15 || (v.abs() < 1e-9 && v != 0)) {
      return v.toStringAsExponential(6);
    }

    // Format with chosen precision
    String s = v.toStringAsFixed(_precision);
    
    // Remove trailing zeros and unnecessary decimal point
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');

    // Re-apply grouping/separators using the NumberFormat
    if (!s.contains('e')) {
      bool isNegative = s.startsWith('-');
      String cleanS = isNegative ? s.substring(1) : s;
      List<String> parts = cleanS.split('.');
      
      try {
        // Format the whole number part with separators
        BigInt wholePart = BigInt.parse(parts[0]);
        String formattedWhole = nf.format(wholePart);
        if (isNegative) formattedWhole = '-$formattedWhole';
        
        return parts.length > 1 
            ? '$formattedWhole${nf.symbols.DECIMAL_SEP}${parts[1]}' 
            : formattedWhole;
      } catch (_) {
        return s; // Fallback to raw string if parsing fails
      }
    }

    return s;
  }
}
