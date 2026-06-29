import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Formula Data Model ────────────────────────────────────────────────────────
class FormulaItem {
  final String name;
  final String formula;
  final String category;
  final String description;
  final Map<String, String> variables;
  const FormulaItem({
    required this.name,
    required this.formula,
    required this.category,
    this.description = '',
    this.variables = const {},
  });
}

class FormulaData {
  static const List<FormulaItem> all = [
    // ── Mathematics ───────────────────────────────────────────────────────────
    FormulaItem(name: 'Quadratic Formula', formula: 'x = (-b ± √(b²-4ac)) / 2a', category: 'Math', description: 'Solves ax² + bx + c = 0', variables: {'a': 'coefficient of x²', 'b': 'coefficient of x', 'c': 'constant term'}),
    FormulaItem(name: 'Pythagorean Theorem', formula: 'a² + b² = c²', category: 'Math', description: 'Relation between sides of a right triangle', variables: {'a,b': 'legs of triangle', 'c': 'hypotenuse'}),
    FormulaItem(name: 'Arithmetic Series Sum', formula: 'S = n/2 × (a + l)', category: 'Math', variables: {'n': 'number of terms', 'a': 'first term', 'l': 'last term'}),
    FormulaItem(name: 'Geometric Series Sum', formula: 'S = a(1 - rⁿ) / (1 - r)', category: 'Math', variables: {'a': 'first term', 'r': 'common ratio', 'n': 'number of terms'}),
    FormulaItem(name: 'Logarithm Change of Base', formula: 'log_a(b) = ln(b) / ln(a)', category: 'Math'),
    FormulaItem(name: 'Binomial Theorem', formula: '(a+b)ⁿ = Σ C(n,k) aⁿ⁻ᵏ bᵏ', category: 'Math'),
    FormulaItem(name: 'Distance Formula', formula: 'd = √((x₂-x₁)² + (y₂-y₁)²)', category: 'Math'),
    FormulaItem(name: 'Midpoint Formula', formula: 'M = ((x₁+x₂)/2, (y₁+y₂)/2)', category: 'Math'),
    FormulaItem(name: 'Slope Formula', formula: 'm = (y₂-y₁) / (x₂-x₁)', category: 'Math'),
    // ── Physics ───────────────────────────────────────────────────────────────
    FormulaItem(name: "Newton's Second Law", formula: 'F = ma', category: 'Physics', description: 'Force equals mass times acceleration', variables: {'F': 'Force (N)', 'm': 'Mass (kg)', 'a': 'Acceleration (m/s²)'}),
    FormulaItem(name: 'Kinetic Energy', formula: 'KE = ½mv²', category: 'Physics', variables: {'m': 'mass (kg)', 'v': 'velocity (m/s)'}),
    FormulaItem(name: 'Potential Energy', formula: 'PE = mgh', category: 'Physics', variables: {'m': 'mass', 'g': '9.81 m/s²', 'h': 'height (m)'}),
    FormulaItem(name: "Ohm's Law", formula: 'V = IR', category: 'Physics', variables: {'V': 'Voltage (V)', 'I': 'Current (A)', 'R': 'Resistance (Ω)'}),
    FormulaItem(name: 'Power', formula: 'P = VI = I²R = V²/R', category: 'Physics'),
    FormulaItem(name: 'Wave Speed', formula: 'v = fλ', category: 'Physics', variables: {'f': 'frequency (Hz)', 'λ': 'wavelength (m)'}),
    FormulaItem(name: 'Einstein Mass-Energy', formula: 'E = mc²', category: 'Physics', variables: {'m': 'mass (kg)', 'c': '3×10⁸ m/s'}),
    FormulaItem(name: 'Gravitational Force', formula: 'F = Gm₁m₂/r²', category: 'Physics'),
    FormulaItem(name: 'Pressure', formula: 'P = F/A', category: 'Physics', variables: {'F': 'Force (N)', 'A': 'Area (m²)'}),
    // ── Chemistry ─────────────────────────────────────────────────────────────
    FormulaItem(name: 'Ideal Gas Law', formula: 'PV = nRT', category: 'Chemistry', variables: {'P': 'Pressure', 'V': 'Volume', 'n': 'moles', 'R': '8.314 J/mol·K', 'T': 'Temperature (K)'}),
    FormulaItem(name: 'Molarity', formula: 'M = n/V', category: 'Chemistry', variables: {'n': 'moles of solute', 'V': 'volume of solution (L)'}),
    FormulaItem(name: 'pH Formula', formula: 'pH = -log[H⁺]', category: 'Chemistry'),
    FormulaItem(name: 'Molar Mass', formula: 'M = m/n', category: 'Chemistry', variables: {'m': 'mass (g)', 'n': 'amount (mol)'}),
    // ── Geometry ──────────────────────────────────────────────────────────────
    FormulaItem(name: 'Circle Area', formula: 'A = πr²', category: 'Geometry', variables: {'r': 'radius'}),
    FormulaItem(name: 'Circle Circumference', formula: 'C = 2πr', category: 'Geometry'),
    FormulaItem(name: 'Sphere Volume', formula: 'V = (4/3)πr³', category: 'Geometry'),
    FormulaItem(name: 'Cylinder Volume', formula: 'V = πr²h', category: 'Geometry'),
    FormulaItem(name: 'Cone Volume', formula: 'V = (1/3)πr²h', category: 'Geometry'),
    FormulaItem(name: 'Triangle Area', formula: 'A = ½bh', category: 'Geometry'),
    FormulaItem(name: "Heron's Formula", formula: 'A = √(s(s-a)(s-b)(s-c))', category: 'Geometry', description: 's = (a+b+c)/2'),
    FormulaItem(name: 'Rectangle Area', formula: 'A = lw', category: 'Geometry'),
    FormulaItem(name: 'Trapezoid Area', formula: 'A = ½(a+b)h', category: 'Geometry'),
  ];
}

// ── Screen ────────────────────────────────────────────────────────────────────
class FormulaScreen extends StatefulWidget {
  const FormulaScreen({super.key});

  @override
  State<FormulaScreen> createState() => _FormulaScreenState();
}

class _FormulaScreenState extends State<FormulaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _search = '';

  final List<String> _tabs = ['All', 'Math', 'Physics', 'Chemistry', 'Geometry'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: _tabs.length, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<FormulaItem> get _filtered {
    final cat = _tabs[_tabCtrl.index];
    return FormulaData.all.where((f) {
      final matchCat = cat == 'All' || f.category == cat;
      final matchSearch = _search.isEmpty ||
          f.name.toLowerCase().contains(_search.toLowerCase()) ||
          f.formula.toLowerCase().contains(_search.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Math':      return AppTheme.primaryBlue;
      case 'Physics':   return AppTheme.primaryPurple;
      case 'Chemistry': return AppTheme.accentGreen;
      case 'Geometry':  return AppTheme.accentOrange;
      default:          return AppTheme.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.textDark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Formula Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          labelColor: AppTheme.primaryBlue,
          indicatorColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textGrey,
          tabAlignment: TabAlignment.start,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search formulas...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppTheme.textGrey),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _formulaCard(_filtered[i], cardColor, textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _formulaCard(FormulaItem f, Color cardColor, Color textColor) => GestureDetector(
        onTap: () => _showDetail(f),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04), blurRadius: 10)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _catColor(f.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(f.category,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: _catColor(f.category))),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppTheme.textGrey.withOpacity(0.5)),
                ],
              ),
              const SizedBox(height: 8),
              Text(f.name,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor)),
              const SizedBox(height: 4),
              Text(f.formula,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                      fontFamily: 'monospace')),
              if (f.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(f.description,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textGrey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
      );

  void _showDetail(FormulaItem f) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final textColor = isDark ? Colors.white : AppTheme.textDark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: AppTheme.textGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Text(f.name,
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: textColor)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(f.formula,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue,
                      fontFamily: 'monospace'),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            Text('Description',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textGrey.withOpacity(0.7))),
            const SizedBox(height: 4),
            Text(
                f.description.isEmpty
                    ? 'No description available.'
                    : f.description,
                style: TextStyle(fontSize: 15, height: 1.6, color: textColor)),
            if (f.variables.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Variables',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textGrey.withOpacity(0.7))),
              const SizedBox(height: 8),
              ...f.variables.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      Text('${e.key} ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppTheme.primaryBlue,
                              fontFamily: 'monospace')),
                      Text('= ${e.value}',
                          style: const TextStyle(
                              color: AppTheme.textGrey)),
                    ]),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
