// NetCalc Pro — production test suite
// Covers: app boot smoke test + full math parser correctness

import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:netcalc/main.dart';
import 'package:netcalc/screens/calculator_screen.dart';

// Raw parser (no sanitize)
double? parse(String expr) => ExprParserForTest(expr).evaluate();

// Full pipeline: sanitize → parse (use this for user-input expressions)
double? eval(String expr, {String ans = ''}) => evalFull(expr, prevAns: ans);

void main() {
  // ── Smoke test ──────────────────────────────────────────────────────────────
  testWidgets('App boots and shows splash', (WidgetTester tester) async {
    await tester.pumpWidget(const NetCalcProApp());
    await tester.pump();
    expect(find.text('NetCalc Pro'), findsWidgets);
    await tester.pump(const Duration(seconds: 2));
  });

  // ── Arithmetic ─────────────────────────────────────────────────────────────
  group('Arithmetic', () {
    test('2+3 = 5',         () => expect(parse('2+3'), equals(5)));
    test('10-4 = 6',        () => expect(parse('10-4'), equals(6)));
    test('6*7 = 42',        () => expect(parse('6*7'), equals(42)));
    test('8/4 = 2',         () => expect(parse('8/4'), equals(2)));
    test('2+3*4 = 14',      () => expect(parse('2+3*4'), equals(14)));
    test('(2+3)*4 = 20',    () => expect(parse('(2+3)*4'), equals(20)));
    test('-5+10 = 5',       () => expect(parse('-5+10'), equals(5)));
    test('1.5+2.5 = 4',     () => expect(parse('1.5+2.5'), equals(4)));
    test('9/3 = 3',         () => expect(parse('9/3'), equals(3)));
    test('5/0 = null',      () => expect(parse('5/0'), isNull));
    test('100-20*3+10 = 50',() => expect(parse('100-20*3+10'), equals(50)));
    test('((2+3)*(4-1))=15',() => expect(parse('((2+3)*(4-1))'), equals(15)));
    test('0.1+0.2 ≈ 0.3',   () => expect(parse('0.1+0.2'), closeTo(0.3, 1e-9)));
  });

  // ── Powers — right-associative ────────────────────────────────────────────
  group('Powers', () {
    test('2^10 = 1024',          () => expect(parse('2^10'), equals(1024)));
    test('5^2 = 25',             () => expect(parse('5^2'), equals(25)));
    test('2^3^2 = 512',          () => expect(parse('2^3^2'), equals(512)));   // right-assoc
    test('-2^2 = -4',            () => expect(parse('-2^2'), equals(-4)));      // -(2^2)
    test('(-2)^2 = 4',           () => expect(parse('(-2)^2'), equals(4)));
    test('4^0.5 = 2',            () => expect(parse('4^0.5'), equals(2)));
    test('8^(1/3) ≈ 2',          () => expect(parse('8^(1/3)'), closeTo(2, 1e-9)));
  });

  // ── Roots ─────────────────────────────────────────────────────────────────
  group('Roots', () {
    test('sqrt(144)=12',    () => expect(parse('sqrt(144)'), equals(12)));
    test('sqrt(2) correct', () => expect(parse('sqrt(2)'), closeTo(math.sqrt2, 1e-9)));
    test('cbrt(27)=3',      () => expect(parse('cbrt(27)'), closeTo(3, 1e-9)));
    test('cbrt(-8)=-2',     () => expect(parse('cbrt(-8)'), closeTo(-2, 1e-9)));
    test('sqrt(-1)=null',   () => expect(parse('sqrt(-1)'), isNull));
  });

  // ── Trig (degrees) ────────────────────────────────────────────────────────
  group('Trig (degrees)', () {
    test('sin(0)=0',     () => expect(parse('sin(0)'), equals(0)));
    test('sin(30)=0.5',  () => expect(parse('sin(30)'), closeTo(0.5, 1e-9)));
    test('sin(90)=1',    () => expect(parse('sin(90)'), closeTo(1, 1e-9)));
    test('sin(180)=0',   () => expect(parse('sin(180)'), closeTo(0, 1e-9)));
    test('cos(0)=1',     () => expect(parse('cos(0)'), closeTo(1, 1e-9)));
    test('cos(60)=0.5',  () => expect(parse('cos(60)'), closeTo(0.5, 1e-9)));
    test('cos(90)=0',    () => expect(parse('cos(90)'), closeTo(0, 1e-9)));
    test('tan(45)=1',    () => expect(parse('tan(45)'), closeTo(1, 1e-9)));
    test('tan(90)=null', () => expect(parse('tan(90)'), isNull));
    test('tan(-90)=null',() => expect(parse('tan(-90)'), isNull));
    test('asin(1)=90',   () => expect(parse('asin(1)'), closeTo(90, 1e-9)));
    test('acos(1)=0',    () => expect(parse('acos(1)'), closeTo(0, 1e-9)));
    test('atan(1)=45',   () => expect(parse('atan(1)'), closeTo(45, 1e-9)));
  });

  // ── Log / Exp ─────────────────────────────────────────────────────────────
  group('Log and Exp', () {
    test('log(100)=2',  () => expect(parse('log(100)'), closeTo(2, 1e-9)));
    test('log(1)=0',    () => expect(parse('log(1)'), equals(0)));
    test('log(10)=1',   () => expect(parse('log(10)'), closeTo(1, 1e-9)));
    test('ln(e)',       () => expect(parse('ln(2.718281828459045)'), closeTo(1, 1e-9)));
    test('log(-1)=null',() => expect(parse('log(-1)'), isNull));
    test('exp(0)=1',    () => expect(parse('exp(0)'), equals(1)));
    test('exp(1)=e',    () => expect(parse('exp(1)'), closeTo(math.e, 1e-9)));
  });

  // ── Constants ─────────────────────────────────────────────────────────────
  group('Constants', () {
    test('pi value',    () => expect(parse('pi'), closeTo(math.pi, 1e-9)));
    test('pi*2',        () => expect(parse('pi*2'), closeTo(math.pi * 2, 1e-9)));
    test('e constant',  () => expect(parse('e'), closeTo(math.e, 1e-9)));
  });

  // ── Percentage (full pipeline) ────────────────────────────────────────────
  group('Percentage (contextual)', () {
    // Bare %
    test('20% = 0.2',       () => expect(eval('20%'), closeTo(0.2, 1e-9)));
    test('16%+14% = 0.3',   () => expect(eval('16%+14%'), closeTo(0.3, 1e-9)));
    // Android-style contextual
    test('500+20% = 600',   () => expect(eval('500+20%'), closeTo(600, 1e-9)));
    test('200-10% = 180',   () => expect(eval('200-10%'), closeTo(180, 1e-9)));
    // Multiply/divide — bare %
    test('500*20% = 100',   () => expect(eval('500×20%'), closeTo(100, 1e-9)));
    test('50/20% = 250',    () => expect(eval('50÷20%'), closeTo(250, 1e-9)));
  });

  // ── Full pipeline: implicit multiplication + symbols ─────────────────────
  group('Full pipeline (sanitize + parse)', () {
    test('2sin(30) = 1',      () => expect(eval('2sin(30)'), closeTo(1, 1e-9)));
    test('3×(2+1) = 9',       () => expect(eval('3×(2+1)'), closeTo(9, 1e-9)));
    test('10÷2 = 5',          () => expect(eval('10÷2'), closeTo(5, 1e-9)));
    test('5! = 120',          () => expect(eval('5!'), equals(120)));
    test('factorial 0 = 1',   () => expect(eval('0!'), equals(1)));
  });

  // ── Edge cases ────────────────────────────────────────────────────────────
  group('Edge cases', () {
    test('empty = null',       () => expect(parse(''), isNull));
    test('42 alone',           () => expect(parse('42'), equals(42)));
    test('-7 alone',           () => expect(parse('-7'), equals(-7)));
    test('abs(-8)=8',          () => expect(parse('abs(-8)'), equals(8)));
    test('floor(3.9)=3',       () => expect(parse('floor(3.9)'), equals(3)));
    test('ceil(3.1)=4',        () => expect(parse('ceil(3.1)'), equals(4)));
    test('round(3.5)=4',       () => expect(parse('round(3.5)'), equals(4)));
    test('1e6 scientific',     () => expect(parse('1e6'), equals(1000000)));
    test('1.5e3 scientific',   () => expect(parse('1.5e3'), equals(1500)));
  });
}
