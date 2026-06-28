import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  final _dataCtrl = TextEditingController();
  List<double> _data = [];
  Map<String, String> _stats = {};

  // nCr / nPr
  final _nCtrl = TextEditingController();
  final _rCtrl = TextEditingController();
  String _combResult = '';
  String _permResult = '';

  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _dataCtrl.dispose();
    _nCtrl.dispose();
    _rCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _compute() {
    final raw = _dataCtrl.text
        .replaceAll('\n', ',')
        .split(',')
        .map((e) => double.tryParse(e.trim()))
        .whereType<double>()
        .toList()
      ..sort();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric data')),
      );
      return;
    }
    setState(() {
      _data = raw;
      _stats = _computeStats(raw);
    });
  }

  Map<String, String> _computeStats(List<double> d) {
    final n = d.length;
    final sum = d.reduce((a, b) => a + b);
    final mean = sum / n;
    final sorted = [...d]..sort();

    final median = n % 2 == 0
        ? (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2
        : sorted[n ~/ 2].toDouble();

    final variance =
        d.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / n;
    final sampleVariance = n > 1
        ? d.map((x) => math.pow(x - mean, 2)).reduce((a, b) => a + b) / (n - 1)
        : 0.0;

    // Mode
    final freq = <double, int>{};
    for (var x in d) freq[x] = (freq[x] ?? 0) + 1;
    final maxFreq = freq.values.reduce(math.max);
    final modes =
        freq.entries.where((e) => e.value == maxFreq).map((e) => e.key).toList();
    final modeStr = maxFreq == 1 ? 'None' : modes.map(_f).join(', ');

    // Quartiles
    final q1 = _percentile(sorted, 25);
    final q3 = _percentile(sorted, 75);

    return {
      'Count': '$n',
      'Sum': _f(sum),
      'Mean': _f(mean),
      'Median': _f(median),
      'Mode': modeStr,
      'Std Dev (Pop)': _f(math.sqrt(variance)),
      'Std Dev (Samp)': _f(math.sqrt(sampleVariance)),
      'Variance (Pop)': _f(variance),
      'Variance (Samp)': _f(sampleVariance),
      'Min': _f(sorted.first),
      'Max': _f(sorted.last),
      'Range': _f(sorted.last - sorted.first),
      'Q1': _f(q1),
      'Q2 (Median)': _f(median),
      'Q3': _f(q3),
      'IQR': _f(q3 - q1),
    };
  }

  double _percentile(List<double> sorted, double p) {
    final idx = (p / 100) * (sorted.length - 1);
    final lower = sorted[idx.floor()];
    final upper = sorted[idx.ceil()];
    return lower + (upper - lower) * (idx - idx.floor());
  }

  String _f(double v) {
    if (v.isNaN || v.isInfinite) return 'N/A';
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(6)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  void _computeCombPerm() {
    final n = int.tryParse(_nCtrl.text) ?? 0;
    final r = int.tryParse(_rCtrl.text) ?? 0;
    if (n < 0 || r < 0 || r > n) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid values: require 0 ≤ r ≤ n')),
      );
      return;
    }
    setState(() {
      try {
        _combResult = _ncr(n, r).toString();
        _permResult = _npr(n, r).toString();
      } catch (_) {
        _combResult = 'Overflow';
        _permResult = 'Overflow';
      }
    });
  }

  int _fact(int n) {
    if (n <= 1) return 1;
    int f = 1;
    for (int i = 2; i <= n; i++) f *= i;
    return f;
  }

  int _ncr(int n, int r) => _fact(n) ~/ (_fact(r) * _fact(n - r));
  int _npr(int n, int r) => _fact(n) ~/ _fact(n - r);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [Tab(text: 'Descriptive'), Tab(text: 'nCr / nPr')],
          labelColor: AppTheme.primaryBlue,
          indicatorColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textGrey,
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabCtrl,
          children: [_descriptiveTab(), _combPermTab()],
        ),
      ),
    );
  }

  Widget _descriptiveTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
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
                  const Text('Enter Data (comma or newline separated)',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppTheme.textGrey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dataCtrl,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '1, 2, 3, 4, 5',
                      filled: true,
                      fillColor: AppTheme.surface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(14)),
                      child: TextButton(
                          onPressed: _compute,
                          child: const Text('Calculate',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                    ),
                  ),
                ],
              ),
            ),
            if (_stats.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
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
                  children: _stats.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(e.key,
                              style: const TextStyle(
                                  color: AppTheme.textGrey,
                                  fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Text(e.value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      );

  Widget _combPermTab() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Expanded(child: _numField2('n', _nCtrl)),
                      const SizedBox(width: 16),
                      Expanded(child: _numField2('r', _rCtrl)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(14)),
                      child: TextButton(
                          onPressed: _computeCombPerm,
                          child: const Text('Calculate',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_combResult.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    _resultRow('Combinations nCr', _combResult),
                    const Divider(height: 24),
                    _resultRow('Permutations nPr', _permResult),
                  ],
                ),
              ),
          ],
        ),
      );

  Widget _numField2(String label, TextEditingController c) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppTheme.textGrey)),
          const SizedBox(height: 4),
          TextField(
            controller: c,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      );

  Widget _resultRow(String label, String value) => Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppTheme.textGrey, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textDark)),
        ],
      );
}
