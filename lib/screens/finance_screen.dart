import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  int _selected = 0;

  final List<_FinanceTool> _tools = const [
    _FinanceTool('Loan EMI', Icons.account_balance_rounded),
    _FinanceTool('Compound Interest', Icons.trending_up_rounded),
    _FinanceTool('Simple Interest', Icons.calculate_outlined),
    _FinanceTool('VAT', Icons.receipt_long_rounded),
    _FinanceTool('Discount', Icons.local_offer_rounded),
    _FinanceTool('Profit / Loss', Icons.show_chart_rounded),
    _FinanceTool('Tip', Icons.star_outline_rounded),
    _FinanceTool('Savings', Icons.savings_rounded),
    _FinanceTool('ROI', Icons.pie_chart_outline_rounded),
    _FinanceTool('SIP', Icons.auto_graph_rounded),
    _FinanceTool('Break-even', Icons.balance_rounded),
    _FinanceTool('Salary', Icons.payments_rounded),
    _FinanceTool('Commission', Icons.percent_rounded),
    _FinanceTool('Mortgage', Icons.home_rounded),
    _FinanceTool('Inflation', Icons.arrow_upward_rounded),
    _FinanceTool('Currency', Icons.currency_exchange_rounded),
    _FinanceTool('Investment', Icons.candlestick_chart_rounded),
    _FinanceTool('Tax', Icons.account_balance_wallet_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Finance'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _tools.length,
                itemBuilder: (_, i) {
                  final active = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: active ? AppTheme.accentGradient : null,
                        color: active ? null : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(_tools[i].icon,
                              size: 16,
                              color: active ? Colors.white : AppTheme.textGrey),
                          const SizedBox(width: 6),
                          Text(_tools[i].name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: active ? Colors.white : AppTheme.textGrey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: _buildTool(_selected)),
          ],
        ),
      ),
    );
  }

  Widget _buildTool(int i) {
    switch (i) {
      case 0:  return const _LoanEMI();
      case 1:  return const _CompoundInterest();
      case 2:  return const _SimpleInterest();
      case 3:  return const _VATCalc();
      case 4:  return const _DiscountCalc();
      case 5:  return const _ProfitLoss();
      case 6:  return const _TipCalc();
      case 7:  return const _SavingsCalc();
      case 8:  return const _ROICalc();
      case 9:  return const _SIPCalc();
      case 10: return const _BreakEven();
      case 11: return const _SalaryCalc();
      case 12: return const _CommissionCalc();
      case 13: return const _MortgageCalc();
      case 14: return const _InflationCalc();
      case 15: return const _CurrencyCalc();
      case 16: return const _InvestmentCalc();
      case 17: return const _TaxCalc();
      default:
        return Center(
          child: Text('${_tools[i].name}\nComing soon',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textGrey, fontSize: 16)),
        );
    }
  }
}

class _FinanceTool {
  final String name;
  final IconData icon;
  const _FinanceTool(this.name, this.icon);
}

// ── Shared Finance Form ────────────────────────────────────────────────────────
class _FinanceForm extends StatelessWidget {
  final String title;
  final List<_Field> fields;
  final VoidCallback onCalc;
  final List<_Result> results;
  const _FinanceForm({
    required this.title,
    required this.fields,
    required this.onCalc,
    required this.results,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04), blurRadius: 12)
                ],
              ),
              child: Column(
                children: [
                  ...fields.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.label,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textGrey)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: f.ctrl,
                              keyboardType: const TextInputType
                                  .numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                hintText: f.hint,
                                filled: true,
                                fillColor: AppTheme.surface,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(14)),
                      child: TextButton(
                          onPressed: onCalc,
                          child: const Text('Calculate',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700))),
                    ),
                  ),
                ],
              ),
            ),
            if (results.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04), blurRadius: 12)
                  ],
                ),
                child: Column(
                  children: results
                      .map((r) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text(r.label,
                                    style: const TextStyle(
                                        color: AppTheme.textGrey,
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Text(r.value,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textDark)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      );
}

class _Field {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  const _Field(this.label, this.ctrl, this.hint);
}

class _Result {
  final String label;
  final String value;
  const _Result(this.label, this.value);
}

// ── Loan EMI ──────────────────────────────────────────────────────────────────
class _LoanEMI extends StatefulWidget {
  const _LoanEMI();
  @override
  State<_LoanEMI> createState() => _LoanEMIState();
}

class _LoanEMIState extends State<_LoanEMI> {
  final _p = TextEditingController();
  final _r = TextEditingController();
  final _n = TextEditingController();
  String _emi = '', _total = '', _interest = '';

  void _calc() {
    final P = double.tryParse(_p.text) ?? 0;
    final annualRate = double.tryParse(_r.text) ?? 0;
    final months = int.tryParse(_n.text) ?? 0;
    if (P <= 0 || annualRate <= 0 || months <= 0) return;
    final r = annualRate / 12 / 100;
    final emi =
        P * r * math.pow(1 + r, months) / (math.pow(1 + r, months) - 1);
    final total = emi * months;
    setState(() {
      _emi = emi.toStringAsFixed(2);
      _total = total.toStringAsFixed(2);
      _interest = (total - P).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _p.dispose();
    _r.dispose();
    _n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Loan EMI Calculator',
        fields: [
          _Field('Principal Amount', _p, 'e.g. 100000'),
          _Field('Annual Interest Rate (%)', _r, 'e.g. 8.5'),
          _Field('Loan Tenure (months)', _n, 'e.g. 36'),
        ],
        onCalc: _calc,
        results: _emi.isEmpty
            ? []
            : [
                _Result('Monthly EMI', _emi),
                _Result('Total Payment', _total),
                _Result('Total Interest', _interest),
              ],
      );
}

// ── Compound Interest ─────────────────────────────────────────────────────────
class _CompoundInterest extends StatefulWidget {
  const _CompoundInterest();
  @override
  State<_CompoundInterest> createState() => _CIState();
}

class _CIState extends State<_CompoundInterest> {
  final _p = TextEditingController();
  final _r = TextEditingController();
  final _t = TextEditingController();
  final _n = TextEditingController(text: '12');
  String _amount = '', _interest = '';

  void _calc() {
    final P = double.tryParse(_p.text) ?? 0;
    final r = (double.tryParse(_r.text) ?? 0) / 100;
    final t = double.tryParse(_t.text) ?? 0;
    final n = double.tryParse(_n.text) ?? 1;
    final A = P * math.pow(1 + r / n, n * t);
    setState(() {
      _amount = A.toStringAsFixed(2);
      _interest = (A - P).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _p.dispose();
    _r.dispose();
    _t.dispose();
    _n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Compound Interest',
        fields: [
          _Field('Principal (P)', _p, 'e.g. 10000'),
          _Field('Annual Rate % (r)', _r, 'e.g. 7'),
          _Field('Time in years (t)', _t, 'e.g. 5'),
          _Field('Compounds/year (n)', _n, 'e.g. 12'),
        ],
        onCalc: _calc,
        results: _amount.isEmpty
            ? []
            : [
                _Result('Final Amount', _amount),
                _Result('Interest Earned', _interest),
              ],
      );
}

// ── Simple Interest ────────────────────────────────────────────────────────────
class _SimpleInterest extends StatefulWidget {
  const _SimpleInterest();
  @override
  State<_SimpleInterest> createState() => _SIState();
}

class _SIState extends State<_SimpleInterest> {
  final _p = TextEditingController();
  final _r = TextEditingController();
  final _t = TextEditingController();
  String _si = '', _total = '';

  void _calc() {
    final P = double.tryParse(_p.text) ?? 0;
    final r = (double.tryParse(_r.text) ?? 0) / 100;
    final t = double.tryParse(_t.text) ?? 0;
    final si = P * r * t;
    setState(() {
      _si = si.toStringAsFixed(2);
      _total = (P + si).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _p.dispose();
    _r.dispose();
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Simple Interest',
        fields: [
          _Field('Principal (P)', _p, 'e.g. 5000'),
          _Field('Rate % per year (r)', _r, 'e.g. 6'),
          _Field('Time in years (t)', _t, 'e.g. 3'),
        ],
        onCalc: _calc,
        results: _si.isEmpty
            ? []
            : [
                _Result('Simple Interest', _si),
                _Result('Total Amount', _total),
              ],
      );
}

// ── VAT ────────────────────────────────────────────────────────────────────────
class _VATCalc extends StatefulWidget {
  const _VATCalc();
  @override
  State<_VATCalc> createState() => _VATState();
}

class _VATState extends State<_VATCalc> {
  final _amount = TextEditingController();
  final _rate = TextEditingController(text: '16');
  String _vat = '', _total = '';

  void _calc() {
    final a = double.tryParse(_amount.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100;
    final vat = a * r;
    setState(() {
      _vat = vat.toStringAsFixed(2);
      _total = (a + vat).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'VAT Calculator',
        fields: [
          _Field('Net Amount', _amount, 'e.g. 1000'),
          _Field('VAT Rate (%)', _rate, 'e.g. 16'),
        ],
        onCalc: _calc,
        results: _vat.isEmpty
            ? []
            : [
                _Result('VAT Amount', _vat),
                _Result('Total (incl. VAT)', _total),
              ],
      );
}

// ── Discount ──────────────────────────────────────────────────────────────────
class _DiscountCalc extends StatefulWidget {
  const _DiscountCalc();
  @override
  State<_DiscountCalc> createState() => _DiscountState();
}

class _DiscountState extends State<_DiscountCalc> {
  final _price = TextEditingController();
  final _disc = TextEditingController();
  String _savings = '', _final = '';

  void _calc() {
    final p = double.tryParse(_price.text) ?? 0;
    final d = (double.tryParse(_disc.text) ?? 0) / 100;
    final s = p * d;
    setState(() {
      _savings = s.toStringAsFixed(2);
      _final = (p - s).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _price.dispose();
    _disc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Discount Calculator',
        fields: [
          _Field('Original Price', _price, 'e.g. 2000'),
          _Field('Discount (%)', _disc, 'e.g. 20'),
        ],
        onCalc: _calc,
        results: _savings.isEmpty
            ? []
            : [
                _Result('You Save', _savings),
                _Result('Final Price', _final),
              ],
      );
}

// ── Profit / Loss ─────────────────────────────────────────────────────────────
class _ProfitLoss extends StatefulWidget {
  const _ProfitLoss();
  @override
  State<_ProfitLoss> createState() => _PLState();
}

class _PLState extends State<_ProfitLoss> {
  final _cost = TextEditingController();
  final _sell = TextEditingController();
  String _pl = '', _pct = '', _type = '';

  void _calc() {
    final c = double.tryParse(_cost.text) ?? 0;
    final s = double.tryParse(_sell.text) ?? 0;
    final diff = s - c;
    final pct = c == 0 ? 0.0 : (diff / c * 100);
    setState(() {
      _type = diff >= 0 ? 'Profit' : 'Loss';
      _pl = diff.abs().toStringAsFixed(2);
      _pct = pct.abs().toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _cost.dispose();
    _sell.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Profit / Loss',
        fields: [
          _Field('Cost Price', _cost, 'e.g. 500'),
          _Field('Selling Price', _sell, 'e.g. 750'),
        ],
        onCalc: _calc,
        results: _pl.isEmpty
            ? []
            : [
                _Result(_type, _pl),
                _Result('$_type %', '$_pct%'),
              ],
      );
}

// ── Tip ────────────────────────────────────────────────────────────────────────
class _TipCalc extends StatefulWidget {
  const _TipCalc();
  @override
  State<_TipCalc> createState() => _TipState();
}

class _TipState extends State<_TipCalc> {
  final _bill = TextEditingController();
  final _tip = TextEditingController(text: '10');
  final _people = TextEditingController(text: '1');
  String _tipAmt = '', _total = '', _perPerson = '';

  void _calc() {
    final b = double.tryParse(_bill.text) ?? 0;
    final t = (double.tryParse(_tip.text) ?? 0) / 100;
    final p = int.tryParse(_people.text) ?? 1;
    final tip = b * t;
    final total = b + tip;
    setState(() {
      _tipAmt = tip.toStringAsFixed(2);
      _total = total.toStringAsFixed(2);
      _perPerson = (p > 0 ? total / p : total).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _bill.dispose();
    _tip.dispose();
    _people.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Tip Calculator',
        fields: [
          _Field('Bill Amount', _bill, 'e.g. 3500'),
          _Field('Tip (%)', _tip, 'e.g. 10'),
          _Field('Number of People', _people, 'e.g. 3'),
        ],
        onCalc: _calc,
        results: _tipAmt.isEmpty
            ? []
            : [
                _Result('Tip Amount', _tipAmt),
                _Result('Total Bill', _total),
                _Result('Per Person', _perPerson),
              ],
      );
}

// ── Savings ────────────────────────────────────────────────────────────────────
class _SavingsCalc extends StatefulWidget {
  const _SavingsCalc();
  @override
  State<_SavingsCalc> createState() => _SavingsState();
}

class _SavingsState extends State<_SavingsCalc> {
  final _initial = TextEditingController();
  final _monthly = TextEditingController();
  final _rate = TextEditingController(text: '5');
  final _years = TextEditingController();
  String _total = '', _interest = '';

  void _calc() {
    final p = double.tryParse(_initial.text) ?? 0;
    final m = double.tryParse(_monthly.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100 / 12;
    final n = (double.tryParse(_years.text) ?? 0) * 12;
    if (n <= 0) return;
    final fv = r == 0
        ? p + m * n
        : p * math.pow(1 + r, n) + m * (math.pow(1 + r, n) - 1) / r;
    final contributions = p + m * n;
    setState(() {
      _total = fv.toStringAsFixed(2);
      _interest = (fv - contributions).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _initial.dispose();
    _monthly.dispose();
    _rate.dispose();
    _years.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Savings Calculator',
        fields: [
          _Field('Initial Deposit', _initial, 'e.g. 5000'),
          _Field('Monthly Contribution', _monthly, 'e.g. 500'),
          _Field('Annual Interest Rate (%)', _rate, 'e.g. 5'),
          _Field('Years', _years, 'e.g. 10'),
        ],
        onCalc: _calc,
        results: _total.isEmpty
            ? []
            : [
                _Result('Final Amount', _total),
                _Result('Interest Earned', _interest),
              ],
      );
}

// ── ROI ────────────────────────────────────────────────────────────────────────
class _ROICalc extends StatefulWidget {
  const _ROICalc();
  @override
  State<_ROICalc> createState() => _ROIState();
}

class _ROIState extends State<_ROICalc> {
  final _initial = TextEditingController();
  final _final = TextEditingController();
  String _roi = '', _gain = '';

  void _calc() {
    final i = double.tryParse(_initial.text) ?? 0;
    final f = double.tryParse(_final.text) ?? 0;
    if (i <= 0) return;
    final gain = f - i;
    final roi = gain / i * 100;
    setState(() {
      _gain = gain.toStringAsFixed(2);
      _roi = '${roi.toStringAsFixed(2)}%';
    });
  }

  @override
  void dispose() {
    _initial.dispose();
    _final.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'ROI Calculator',
        fields: [
          _Field('Initial Investment', _initial, 'e.g. 10000'),
          _Field('Final Value', _final, 'e.g. 15000'),
        ],
        onCalc: _calc,
        results: _roi.isEmpty
            ? []
            : [
                _Result('Net Gain', _gain),
                _Result('ROI', _roi),
              ],
      );
}

// ── SIP ────────────────────────────────────────────────────────────────────────
class _SIPCalc extends StatefulWidget {
  const _SIPCalc();
  @override
  State<_SIPCalc> createState() => _SIPState();
}

class _SIPState extends State<_SIPCalc> {
  final _monthly = TextEditingController();
  final _rate = TextEditingController(text: '12');
  final _years = TextEditingController();
  String _invested = '', _wealth = '', _returns = '';

  void _calc() {
    final m = double.tryParse(_monthly.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100 / 12;
    final n = (double.tryParse(_years.text) ?? 0) * 12;
    if (n <= 0) return;
    final fv = r == 0 ? m * n : m * (math.pow(1 + r, n) - 1) / r * (1 + r);
    setState(() {
      _invested = (m * n).toStringAsFixed(2);
      _wealth = fv.toStringAsFixed(2);
      _returns = (fv - m * n).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _monthly.dispose();
    _rate.dispose();
    _years.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'SIP Calculator',
        fields: [
          _Field('Monthly Investment', _monthly, 'e.g. 5000'),
          _Field('Expected Return (%/year)', _rate, 'e.g. 12'),
          _Field('Investment Period (years)', _years, 'e.g. 10'),
        ],
        onCalc: _calc,
        results: _wealth.isEmpty
            ? []
            : [
                _Result('Total Invested', _invested),
                _Result('Est. Returns', _returns),
                _Result('Total Wealth', _wealth),
              ],
      );
}

// ── Break-even ─────────────────────────────────────────────────────────────────
class _BreakEven extends StatefulWidget {
  const _BreakEven();
  @override
  State<_BreakEven> createState() => _BreakEvenState();
}

class _BreakEvenState extends State<_BreakEven> {
  final _fixed = TextEditingController();
  final _variable = TextEditingController();
  final _price = TextEditingController();
  String _units = '', _revenue = '';

  void _calc() {
    final fc = double.tryParse(_fixed.text) ?? 0;
    final vc = double.tryParse(_variable.text) ?? 0;
    final sp = double.tryParse(_price.text) ?? 0;
    if (sp <= vc) return;
    final units = fc / (sp - vc);
    setState(() {
      _units = units.toStringAsFixed(0);
      _revenue = (units * sp).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _fixed.dispose();
    _variable.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Break-even Point',
        fields: [
          _Field('Fixed Costs', _fixed, 'e.g. 50000'),
          _Field('Variable Cost per Unit', _variable, 'e.g. 30'),
          _Field('Selling Price per Unit', _price, 'e.g. 80'),
        ],
        onCalc: _calc,
        results: _units.isEmpty
            ? []
            : [
                _Result('Break-even Units', _units),
                _Result('Break-even Revenue', _revenue),
              ],
      );
}

// ── Salary ─────────────────────────────────────────────────────────────────────
class _SalaryCalc extends StatefulWidget {
  const _SalaryCalc();
  @override
  State<_SalaryCalc> createState() => _SalaryState();
}

class _SalaryState extends State<_SalaryCalc> {
  final _annual = TextEditingController();
  final _tax = TextEditingController(text: '20');
  String _monthly = '', _weekly = '', _daily = '', _net = '';

  void _calc() {
    final a = double.tryParse(_annual.text) ?? 0;
    final t = (double.tryParse(_tax.text) ?? 0) / 100;
    setState(() {
      _monthly = (a / 12).toStringAsFixed(2);
      _weekly = (a / 52).toStringAsFixed(2);
      _daily = (a / 260).toStringAsFixed(2);
      _net = (a * (1 - t)).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _annual.dispose();
    _tax.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Salary Calculator',
        fields: [
          _Field('Annual Gross Salary', _annual, 'e.g. 1200000'),
          _Field('Tax Rate (%)', _tax, 'e.g. 20'),
        ],
        onCalc: _calc,
        results: _monthly.isEmpty
            ? []
            : [
                _Result('Monthly', _monthly),
                _Result('Weekly', _weekly),
                _Result('Daily', _daily),
                _Result('Annual Net', _net),
              ],
      );
}

// ── Commission ─────────────────────────────────────────────────────────────────
class _CommissionCalc extends StatefulWidget {
  const _CommissionCalc();
  @override
  State<_CommissionCalc> createState() => _CommissionState();
}

class _CommissionState extends State<_CommissionCalc> {
  final _sales = TextEditingController();
  final _rate = TextEditingController(text: '5');
  String _commission = '', _net = '';

  void _calc() {
    final s = double.tryParse(_sales.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100;
    final c = s * r;
    setState(() {
      _commission = c.toStringAsFixed(2);
      _net = (s - c).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _sales.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Commission Calculator',
        fields: [
          _Field('Total Sales', _sales, 'e.g. 500000'),
          _Field('Commission Rate (%)', _rate, 'e.g. 5'),
        ],
        onCalc: _calc,
        results: _commission.isEmpty
            ? []
            : [
                _Result('Commission', _commission),
                _Result('Net After Commission', _net),
              ],
      );
}

// ── Mortgage ───────────────────────────────────────────────────────────────────
class _MortgageCalc extends StatefulWidget {
  const _MortgageCalc();
  @override
  State<_MortgageCalc> createState() => _MortgageState();
}

class _MortgageState extends State<_MortgageCalc> {
  final _home = TextEditingController();
  final _down = TextEditingController();
  final _rate = TextEditingController(text: '5.5');
  final _years = TextEditingController(text: '30');
  String _monthly = '', _totalPaid = '', _totalInterest = '';

  void _calc() {
    final H = double.tryParse(_home.text) ?? 0;
    final D = double.tryParse(_down.text) ?? 0;
    final P = H - D;
    final r = (double.tryParse(_rate.text) ?? 0) / 100 / 12;
    final n = (int.tryParse(_years.text) ?? 30) * 12;
    if (P <= 0 || r <= 0) return;
    final m = P * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
    setState(() {
      _monthly = m.toStringAsFixed(2);
      _totalPaid = (m * n).toStringAsFixed(2);
      _totalInterest = (m * n - P).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _home.dispose();
    _down.dispose();
    _rate.dispose();
    _years.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Mortgage Calculator',
        fields: [
          _Field('Home Price', _home, 'e.g. 3000000'),
          _Field('Down Payment', _down, 'e.g. 600000'),
          _Field('Annual Interest Rate (%)', _rate, 'e.g. 5.5'),
          _Field('Loan Term (years)', _years, 'e.g. 30'),
        ],
        onCalc: _calc,
        results: _monthly.isEmpty
            ? []
            : [
                _Result('Monthly Payment', _monthly),
                _Result('Total Paid', _totalPaid),
                _Result('Total Interest', _totalInterest),
              ],
      );
}

// ── Inflation ──────────────────────────────────────────────────────────────────
class _InflationCalc extends StatefulWidget {
  const _InflationCalc();
  @override
  State<_InflationCalc> createState() => _InflationState();
}

class _InflationState extends State<_InflationCalc> {
  final _amount = TextEditingController();
  final _rate = TextEditingController(text: '5');
  final _years = TextEditingController(text: '10');
  String _future = '', _loss = '';

  void _calc() {
    final a = double.tryParse(_amount.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100;
    final t = double.tryParse(_years.text) ?? 0;
    final fv = a * math.pow(1 + r, t);
    setState(() {
      _future = fv.toStringAsFixed(2);
      _loss = (fv - a).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    _years.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Inflation Calculator',
        fields: [
          _Field('Current Amount', _amount, 'e.g. 100000'),
          _Field('Annual Inflation Rate (%)', _rate, 'e.g. 5'),
          _Field('Years', _years, 'e.g. 10'),
        ],
        onCalc: _calc,
        results: _future.isEmpty
            ? []
            : [
                _Result('Future Cost', _future),
                _Result('Additional Cost', _loss),
              ],
      );
}

// ── Currency ───────────────────────────────────────────────────────────────────
class _CurrencyCalc extends StatefulWidget {
  const _CurrencyCalc();
  @override
  State<_CurrencyCalc> createState() => _CurrencyState();
}

class _CurrencyState extends State<_CurrencyCalc> {
  final _amount = TextEditingController();
  final _rate = TextEditingController(text: '1');
  String _result = '';

  void _calc() {
    final a = double.tryParse(_amount.text) ?? 0;
    final r = double.tryParse(_rate.text) ?? 1;
    setState(() {
      _result = (a * r).toStringAsFixed(4);
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Currency Exchange',
        fields: [
          _Field('Amount', _amount, 'e.g. 1000'),
          _Field('Exchange Rate (1 unit = ?)', _rate, 'e.g. 130.5'),
        ],
        onCalc: _calc,
        results: _result.isEmpty
            ? []
            : [_Result('Converted Amount', _result)],
      );
}

// ── Investment Growth ──────────────────────────────────────────────────────────
class _InvestmentCalc extends StatefulWidget {
  const _InvestmentCalc();
  @override
  State<_InvestmentCalc> createState() => _InvestmentState();
}

class _InvestmentState extends State<_InvestmentCalc> {
  final _initial = TextEditingController();
  final _rate = TextEditingController(text: '10');
  final _years = TextEditingController(text: '5');
  String _fv = '', _gain = '';

  void _calc() {
    final p = double.tryParse(_initial.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100;
    final t = double.tryParse(_years.text) ?? 0;
    final fv = p * math.pow(1 + r, t);
    setState(() {
      _fv = fv.toStringAsFixed(2);
      _gain = (fv - p).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _initial.dispose();
    _rate.dispose();
    _years.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Investment Growth',
        fields: [
          _Field('Initial Investment', _initial, 'e.g. 50000'),
          _Field('Annual Return (%)', _rate, 'e.g. 10'),
          _Field('Years', _years, 'e.g. 5'),
        ],
        onCalc: _calc,
        results: _fv.isEmpty
            ? []
            : [
                _Result('Future Value', _fv),
                _Result('Total Gain', _gain),
              ],
      );
}

// ── Tax ────────────────────────────────────────────────────────────────────────
class _TaxCalc extends StatefulWidget {
  const _TaxCalc();
  @override
  State<_TaxCalc> createState() => _TaxState();
}

class _TaxState extends State<_TaxCalc> {
  final _income = TextEditingController();
  final _rate = TextEditingController(text: '25');
  String _tax = '', _net = '';

  void _calc() {
    final i = double.tryParse(_income.text) ?? 0;
    final r = (double.tryParse(_rate.text) ?? 0) / 100;
    final tax = i * r;
    setState(() {
      _tax = tax.toStringAsFixed(2);
      _net = (i - tax).toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _income.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _FinanceForm(
        title: 'Tax Calculator',
        fields: [
          _Field('Gross Income', _income, 'e.g. 500000'),
          _Field('Tax Rate (%)', _rate, 'e.g. 25'),
        ],
        onCalc: _calc,
        results: _tax.isEmpty
            ? []
            : [
                _Result('Tax Amount', _tax),
                _Result('Net Income', _net),
              ],
      );
}
