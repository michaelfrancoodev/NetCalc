import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UnitConversionScreen extends StatefulWidget {
  const UnitConversionScreen({super.key});

  @override
  State<UnitConversionScreen> createState() => _UnitConversionScreenState();
}

class _UnitConversionScreenState extends State<UnitConversionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<String> _categories = [
    'Length', 'Weight', 'Temperature', 'Area', 'Volume', 'Speed'
  ];

  int _catIndex = 0;
  final TextEditingController _inputCtrl = TextEditingController();
  String _fromUnit = '';
  String _toUnit = '';
  String _convertedValue = '';

  static const Map<String, List<String>> _units = {
    'Length':      ['Meter', 'Kilometer', 'Centimeter', 'Millimeter', 'Mile', 'Yard', 'Foot', 'Inch'],
    'Weight':      ['Kilogram', 'Gram', 'Milligram', 'Pound', 'Ounce', 'Ton'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
    'Area':        ['Square Meter', 'Square Kilometer', 'Hectare', 'Acre', 'Square Foot', 'Square Inch'],
    'Volume':      ['Liter', 'Milliliter', 'Cubic Meter', 'Gallon (US)', 'Pint', 'Fluid Ounce'],
    'Speed':       ['m/s', 'km/h', 'mph', 'Knot', 'ft/s'],
  };

  static const Map<String, Map<String, double>> _toBase = {
    'Length': {
      'Meter': 1, 'Kilometer': 1000, 'Centimeter': 0.01, 'Millimeter': 0.001,
      'Mile': 1609.344, 'Yard': 0.9144, 'Foot': 0.3048, 'Inch': 0.0254,
    },
    'Weight': {
      'Kilogram': 1, 'Gram': 0.001, 'Milligram': 0.000001,
      'Pound': 0.453592, 'Ounce': 0.0283495, 'Ton': 1000,
    },
    'Area': {
      'Square Meter': 1, 'Square Kilometer': 1e6, 'Hectare': 10000,
      'Acre': 4046.856, 'Square Foot': 0.092903, 'Square Inch': 0.00064516,
    },
    'Volume': {
      'Liter': 1, 'Milliliter': 0.001, 'Cubic Meter': 1000,
      'Gallon (US)': 3.78541, 'Pint': 0.473176, 'Fluid Ounce': 0.0295735,
    },
    'Speed': {
      'm/s': 1, 'km/h': 0.277778, 'mph': 0.44704, 'Knot': 0.514444, 'ft/s': 0.3048,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _catIndex = _tabController.index;
          _fromUnit = _currentUnits.first;
          _toUnit = _currentUnits.length > 1 ? _currentUnits[1] : _currentUnits.first;
          _convertedValue = '';
          _inputCtrl.clear();
        });
      }
    });
    _fromUnit = _currentUnits.first;
    _toUnit = _currentUnits[1];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _inputCtrl.dispose();
    super.dispose();
  }

  List<String> get _currentUnits => _units[_categories[_catIndex]]!;
  String get _category => _categories[_catIndex];

  void _convert() {
    final val = double.tryParse(_inputCtrl.text);
    if (val == null) {
      setState(() => _convertedValue = 'Invalid input');
      return;
    }
    double result;
    if (_category == 'Temperature') {
      result = _convertTemperature(val, _fromUnit, _toUnit);
    } else {
      final baseMap = _toBase[_category]!;
      final fromFactor = baseMap[_fromUnit] ?? 1;
      final toFactor = baseMap[_toUnit] ?? 1;
      result = val * fromFactor / toFactor;
    }
    String formatted;
    if (result.abs() >= 1e12 || (result.abs() < 1e-8 && result != 0)) {
      formatted = result.toStringAsExponential(6).replaceAll(RegExp(r'\.?0+e'), 'e');
    } else {
      formatted = result.toStringAsFixed(10).replaceAll(RegExp(r'\.?0+$'), '');
    }
    setState(() => _convertedValue = formatted);
  }

  double _convertTemperature(double val, String from, String to) {
    double c;
    switch (from) {
      case 'Fahrenheit': c = (val - 32) * 5 / 9; break;
      case 'Kelvin': c = val - 273.15; break;
      default: c = val;
    }
    switch (to) {
      case 'Fahrenheit': return c * 9 / 5 + 32;
      case 'Kelvin': return c + 273.15;
      default: return c;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainBackground),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.textDark, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Unit Converter',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textDark)),
                  ],
                ),
              ),

              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppTheme.primaryBlue,
                indicatorWeight: 2,
                labelColor: AppTheme.primaryBlue,
                unselectedLabelColor: AppTheme.textGrey,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.black12,
                tabs: _categories.map((c) => Tab(text: c)).toList(),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const _SectionLabel(label: 'Value'),
                      const SizedBox(height: 8),
                      _GlassInput(
                        controller: _inputCtrl,
                        hint: 'Enter value...',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        onChanged: (_) => _convert(),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionLabel(label: 'From'),
                                const SizedBox(height: 8),
                                _GlassDropdown(
                                  value: _fromUnit,
                                  items: _currentUnits,
                                  onChanged: (v) {
                                    setState(() => _fromUnit = v!);
                                    _convert();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 28),
                            child: IconButton(
                              icon: const Icon(Icons.swap_horiz_rounded,
                                  color: AppTheme.primaryBlue, size: 26),
                              onPressed: () {
                                setState(() {
                                  final tmp = _fromUnit;
                                  _fromUnit = _toUnit;
                                  _toUnit = tmp;
                                });
                                _convert();
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionLabel(label: 'To'),
                                const SizedBox(height: 8),
                                _GlassDropdown(
                                  value: _toUnit,
                                  items: _currentUnits,
                                  onChanged: (v) {
                                    setState(() => _toUnit = v!);
                                    _convert();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppTheme.displayGradient,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${_inputCtrl.text.isEmpty ? "0" : _inputCtrl.text} $_fromUnit',
                              style: const TextStyle(
                                  fontSize: 16, color: AppTheme.textGrey, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 6),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _convertedValue.isEmpty ? '—' : '$_convertedValue $_toUnit',
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: AppTheme.textDark,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textGrey,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8),
      );
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;

  const _GlassInput({
    required this.controller,
    required this.hint,
    required this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppTheme.textDark, fontSize: 18),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.2), fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class _GlassDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _GlassDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : items.first,
          isExpanded: true,
          dropdownColor: Colors.white,
          icon: const Icon(Icons.expand_more_rounded,
              color: AppTheme.textGrey, size: 20),
          style: const TextStyle(color: AppTheme.textDark, fontSize: 14),
          items: items
              .map((u) => DropdownMenuItem(
                    value: u,
                    child: Text(u,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
