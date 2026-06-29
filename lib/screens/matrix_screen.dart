import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key});

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  int _rowsA = 2, _colsA = 2;
  int _rowsB = 2, _colsB = 2;
  late List<List<TextEditingController>> _aCtrl;
  late List<List<TextEditingController>> _bCtrl;
  List<List<double>>? _result;
  double? _det;
  String _operation = 'Multiply';
  String _resultLabel = '';
  String? _error;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers({bool disposeExisting = false}) {
    // Dispose existing before recreating
    if (disposeExisting) {
      try {
        for (var row in _aCtrl) {
          for (var c in row) {
            c.dispose();
          }
        }
        for (var row in _bCtrl) {
          for (var c in row) {
            c.dispose();
          }
        }
      } catch (_) {}
    }
    _aCtrl = List.generate(
        _rowsA, (_) => List.generate(_colsA, (_) => TextEditingController(text: '0')));
    _bCtrl = List.generate(
        _rowsB, (_) => List.generate(_colsB, (_) => TextEditingController(text: '0')));
  }

  List<List<double>> _readMatrix(List<List<TextEditingController>> c) =>
      c.map((row) => row.map((e) => double.tryParse(e.text) ?? 0).toList()).toList();

  void _compute() {
    final A = _readMatrix(_aCtrl);
    final B = _readMatrix(_bCtrl);
    setState(() {
      _det = null;
      _error = null;
      try {
        switch (_operation) {
          case 'Add':
            if (_rowsA != _rowsB || _colsA != _colsB) {
              _error = 'Matrices must have the same dimensions for addition.';
              return;
            }
            _result = List.generate(
                _rowsA, (i) => List.generate(_colsA, (j) => A[i][j] + B[i][j]));
            _resultLabel = 'A + B';
            break;
          case 'Subtract':
            if (_rowsA != _rowsB || _colsA != _colsB) {
              _error = 'Matrices must have the same dimensions for subtraction.';
              return;
            }
            _result = List.generate(
                _rowsA, (i) => List.generate(_colsA, (j) => A[i][j] - B[i][j]));
            _resultLabel = 'A − B';
            break;
          case 'Multiply':
            if (_colsA != _rowsB) {
              _error = 'Columns of A must equal rows of B for multiplication.';
              return;
            }
            _result = _multiply(A, B);
            _resultLabel = 'A × B';
            break;
          case 'Transpose':
            _result = _transpose(A);
            _resultLabel = 'Aᵀ';
            break;
          case 'Determinant':
            if (_rowsA != _colsA) {
              _error = 'Determinant requires a square matrix.';
              return;
            }
            _det = _determinant(A);
            _result = null;
            _resultLabel = 'det(A)';
            break;
        }
      } catch (e) {
        _error = 'Computation error: ${e.toString()}';
      }
    });
  }

  List<List<double>> _multiply(List<List<double>> a, List<List<double>> b) {
    final r = a.length, m = b.length, c = b[0].length;
    return List.generate(r, (i) => List.generate(c, (j) {
          double s = 0;
          for (int k = 0; k < m; k++) {
            s += a[i][k] * b[k][j];
          }
          return s;
        }));
  }

  List<List<double>> _transpose(List<List<double>> m) =>
      List.generate(m[0].length, (i) => List.generate(m.length, (j) => m[j][i]));

  double _determinant(List<List<double>> m) {
    if (m.length == 1) return m[0][0];
    if (m.length == 2) return m[0][0] * m[1][1] - m[0][1] * m[1][0];
    double d = 0;
    for (int c = 0; c < m.length; c++) {
      final sub = List.generate(m.length - 1,
          (i) => List.generate(m.length - 1, (j) => m[i + 1][j < c ? j : j + 1]));
      d += (c % 2 == 0 ? 1 : -1) * m[0][c] * _determinant(sub);
    }
    return d;
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  void dispose() {
    for (var row in _aCtrl) {
      for (var c in row) {
        c.dispose();
      }
    }
    for (var row in _bCtrl) {
      for (var c in row) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final textColor = isDark ? Colors.white : AppTheme.textDark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Matrix Calculator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Operation selector
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Add', 'Subtract', 'Multiply', 'Transpose', 'Determinant']
                      .map((op) {
                    final active = _operation == op;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _operation = op;
                          _result = null;
                          _det = null;
                          _error = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: active ? AppTheme.accentGradient : null,
                            color: active ? null : cardColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6)
                            ],
                          ),
                          child: Text(op,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: active ? Colors.white : AppTheme.textGrey)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Matrix A
              _matrixCard('Matrix A', _aCtrl, _rowsA, _colsA, cardColor, textColor,
                  onRows: (v) => setState(() {
                        _rowsA = v;
                        _initControllers(disposeExisting: true);
                      }),
                  onCols: (v) => setState(() {
                        _colsA = v;
                        _initControllers(disposeExisting: true);
                      })),
              const SizedBox(height: 16),

              // Matrix B (hidden for Transpose and Determinant)
              if (!['Transpose', 'Determinant'].contains(_operation))
                _matrixCard('Matrix B', _bCtrl, _rowsB, _colsB, cardColor, textColor,
                    onRows: (v) => setState(() {
                          _rowsB = v;
                          _initControllers(disposeExisting: true);
                        }),
                    onCols: (v) => setState(() {
                          _colsB = v;
                          _initControllers(disposeExisting: true);
                        })),

              const SizedBox(height: 20),

              // Compute button
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
                      ]),
                  child: TextButton(
                    onPressed: _compute,
                    child: const Text('Compute',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Error
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.textPink.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.textPink.withOpacity(0.3)),
                  ),
                  child: Text(_error!,
                      style: const TextStyle(
                          color: AppTheme.textPink, fontWeight: FontWeight.w500)),
                ),

              // Result
              if (_result != null || _det != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04), blurRadius: 12)
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_resultLabel,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textGrey,
                              fontSize: 13)),
                      const SizedBox(height: 12),
                      if (_det != null)
                        Text(_fmt(_det!),
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: textColor)),
                      if (_result != null)
                        ..._result!.map((row) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: row.map((v) => Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.white10 : AppTheme.surface,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(_fmt(v),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    )).toList(),
                              ),
                            )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _matrixCard(
      String title,
      List<List<TextEditingController>> ctrl,
      int rows,
      int cols,
      Color cardColor,
      Color textColor,
      {required void Function(int) onRows,
      required void Function(int) onCols}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
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
              Text(title,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              _dimPicker('Rows', rows, onRows),
              const SizedBox(width: 8),
              _dimPicker('Cols', cols, onCols),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(rows, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: List.generate(cols, (j) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: TextField(
                        controller: ctrl[i][j],
                        style: TextStyle(color: textColor),
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? Colors.white10 : AppTheme.surface,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dimPicker(String label, int val, void Function(int) onChange) =>
      Row(children: [
        Text('$label:',
            style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
        const SizedBox(width: 4),
        DropdownButton<int>(
          value: val,
          items: [1, 2, 3, 4]
              .map((v) =>
                  DropdownMenuItem(value: v, child: Text('$v')))
              .toList(),
          onChanged: (v) => onChange(v!),
          underline: const SizedBox(),
          style: const TextStyle(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: 'Roboto'),
        ),
      ]);
}
