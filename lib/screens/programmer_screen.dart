import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class ProgrammerScreen extends StatefulWidget {
  const ProgrammerScreen({super.key});

  @override
  State<ProgrammerScreen> createState() => _ProgrammerScreenState();
}

class _ProgrammerScreenState extends State<ProgrammerScreen> {
  String _input = '';
  int _value = 0;
  String _base = 'DEC'; // DEC, HEX, OCT, BIN
  int _bits = 32;

  // Two-operand bitwise operation state
  int? _operand1;
  String? _pendingOp;

  int get _mask {
    switch (_bits) {
      case 8:  return 0xFF;
      case 16: return 0xFFFF;
      case 64: return 0x7FFFFFFFFFFFFFFF;
      default: return 0xFFFFFFFF;
    }
  }

  void _parse() {
    try {
      switch (_base) {
        case 'DEC': _value = int.parse(_input.isEmpty ? '0' : _input); break;
        case 'HEX': _value = int.parse(_input.isEmpty ? '0' : _input, radix: 16); break;
        case 'OCT': _value = int.parse(_input.isEmpty ? '0' : _input, radix: 8); break;
        case 'BIN': _value = int.parse(_input.isEmpty ? '0' : _input, radix: 2); break;
      }
      _value &= _mask;
    } catch (_) {
      _value = 0;
    }
  }

  String _displayFor(int v, String base) {
    switch (base) {
      case 'HEX': return v.toRadixString(16).toUpperCase();
      case 'OCT': return v.toRadixString(8);
      case 'BIN':
        final s = v.toRadixString(2).padLeft(_bits, '0');
        // Group into nibbles
        return s.replaceAllMapped(RegExp(r'.{4}(?=.+)'), (m) => '${m[0]} ').trim();
      default: return v.toString();
    }
  }

  void _handleTap(String l) {
    HapticFeedback.selectionClick();
    setState(() {
      switch (l) {
        case 'AC':
          _input = '';
          _value = 0;
          _operand1 = null;
          _pendingOp = null;
          break;
        case 'DEL':
          if (_input.isNotEmpty) {
            _input = _input.substring(0, _input.length - 1);
            _parse();
          }
          break;
        case 'NOT':
          _value = (~_value) & _mask;
          _input = _displayFor(_value, _base);
          break;
        case 'LSH':
          _value = (_value << 1) & _mask;
          _input = _displayFor(_value, _base);
          break;
        case 'RSH':
          _value = _value >> 1;
          _input = _displayFor(_value, _base);
          break;
        case 'AND':
        case 'OR':
        case 'XOR':
        case 'NAND':
        case 'NOR':
          _parse();
          _operand1 = _value;
          _pendingOp = l;
          _input = '';
          break;
        case '=':
          if (_operand1 != null && _pendingOp != null) {
            _parse();
            final a = _operand1!;
            final b = _value;
            switch (_pendingOp) {
              case 'AND':  _value = (a & b) & _mask; break;
              case 'OR':   _value = (a | b) & _mask; break;
              case 'XOR':  _value = (a ^ b) & _mask; break;
              case 'NAND': _value = (~(a & b)) & _mask; break;
              case 'NOR':  _value = (~(a | b)) & _mask; break;
            }
            _operand1 = null;
            _pendingOp = null;
            _input = _displayFor(_value, _base);
          }
          break;
        case 'MOD':
          if (_value != 0) {
            _parse();
            _operand1 = _value;
            _pendingOp = 'MOD';
            _input = '';
          }
          break;
        default:
          _input += l;
          _parse();
      }
    });
  }

  bool _isValidDigit(String d) {
    switch (_base) {
      case 'BIN': return ['0', '1'].contains(d);
      case 'OCT': return '01234567'.contains(d);
      case 'DEC': return '0123456789'.contains(d);
      case 'HEX': return '0123456789ABCDEF'.contains(d.toUpperCase());
      default:    return false;
    }
  }

  bool _isOp(String l) => [
        'AND', 'OR', 'XOR', 'NOT', 'NAND', 'NOR', 'LSH', 'RSH',
        'MOD', 'AC', 'DEL', '='
      ].contains(l);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Programmer'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Base display ──────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04), blurRadius: 16)
                ],
              ),
              child: Column(
                children: [
                  _baseRow('HEX', 16),
                  const Divider(height: 12),
                  _baseRow('DEC', 10),
                  const Divider(height: 12),
                  _baseRow('OCT', 8),
                  const Divider(height: 12),
                  _baseRow('BIN', 2),
                ],
              ),
            ),

            // ── Bit size selector ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [8, 16, 32, 64].map((b) {
                final sel = _bits == b;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _bits = b;
                      _value &= _mask;
                      _input = _displayFor(_value, _base);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppTheme.primaryBlue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 4)
                        ],
                      ),
                      child: Text('$b-bit',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: sel ? Colors.white : AppTheme.textGrey)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 8),

            // ── Keypad ────────────────────────────────────────────────────
            Expanded(child: _buildKeypad()),
          ],
        ),
      ),
    );
  }

  Widget _baseRow(String label, int radix) {
    final active = _base == label;
    return GestureDetector(
      onTap: () => setState(() {
        _base = label;
        _input = _displayFor(_value, label);
      }),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: active ? AppTheme.primaryBlue : AppTheme.textGrey,
                    fontSize: 13)),
          ),
          Expanded(
            child: Text(
              _displayFor(_value, label),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: active ? 20 : 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? AppTheme.textDark : AppTheme.textGrey,
                  fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    final hexExtra = _base == 'HEX';
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))
        ],
      ),
      child: Column(
        children: [
          _pRow(['AND', 'OR', 'XOR', 'NOT', 'MOD']),
          _pRow(['LSH', 'RSH', 'NAND', 'NOR', 'AC']),
          if (hexExtra) ...[
            _pRow(['A', 'B', 'C', 'D', 'E']),
            _pRow(['F', '7', '8', '9', 'DEL']),
            _pRow(['4', '5', '6', '(', ')']),
          ] else ...[
            _pRow(['7', '8', '9', 'DEL', '=']),
            _pRow(['4', '5', '6', '(', ')']),
          ],
          _pRow(['1', '2', '3', '0', '=']),
        ],
      ),
    );
  }

  Widget _pRow(List<String> labels) => Expanded(
        child: Row(
          children: labels.map((l) {
            final enabled = _isOp(l) || _isValidDigit(l) || l == '(' || l == ')' || l == '=';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isOp(l)
                        ? AppTheme.primaryBlue.withOpacity(0.1)
                        : AppTheme.surface,
                    foregroundColor:
                        _isOp(l) ? AppTheme.primaryBlue : AppTheme.textDark,
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.05),
                    disabledForegroundColor: Colors.grey.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: enabled ? () => _handleTap(l) : null,
                  child: Text(l,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ),
            );
          }).toList(),
        ),
      );
}
