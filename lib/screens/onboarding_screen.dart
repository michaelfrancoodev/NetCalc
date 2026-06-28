import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'calculator_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Professional Scientific Calculator",
      description: "Solve everyday calculations, advanced mathematics, engineering problems, and academic equations from one application.",
      icon: Icons.calculate_rounded,
    ),
    OnboardingData(
      title: "Everything You Need in One Place",
      description: "Instantly convert units, perform financial calculations, and access formulas without switching between multiple applications.",
      icon: Icons.auto_awesome_motion_rounded,
    ),
    OnboardingData(
      title: "Fast, Beautiful and Personal",
      description: "NetCalc Pro remembers calculation history, supports favorite formulas, and provides a smooth premium user experience.",
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CalculatorScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient + Decorative Elements
          const _OnboardingBackground(),
          
          SafeArea(
            child: Column(
              children: [
                // Top Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FadeInAnimation(
                      delay: 200,
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.6),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        child: const Text("Skip", style: TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _OnboardingPage(data: _pages[index]);
                    },
                  ),
                ),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  child: Column(
                    children: [
                      // Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_pages.length, (index) => _buildIndicator(index)),
                      ),
                      const SizedBox(height: 32),
                      
                      // Primary Button
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutCubic,
                            );
                          } else {
                            _completeOnboarding();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: AppTheme.accentGradient,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _currentPage == _pages.length - 1 ? "Get Started" : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        gradient: isActive ? AppTheme.accentGradient : null,
        color: isActive ? null : Colors.black12,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration Area
          FadeInAnimation(
            delay: 100,
            slideOffset: 40.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 40,
                  )
                ],
              ),
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => AppTheme.accentGradient.createShader(bounds),
                  child: Icon(data.icon, size: 130, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
          
          // Title
          FadeInAnimation(
            delay: 300,
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          
          // Description
          FadeInAnimation(
            delay: 500,
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppTheme.textGrey,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFF2F7FF),
                Color(0xFFF7F2FF),
                Color(0xFFF0FFFE),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Faint Floating Decorations
        const _FloatingElement(
          top: 120, left: -30,
          child: Icon(Icons.grid_4x4_rounded, size: 220, color: Color(0x089061FF)),
        ),
        const _FloatingElement(
          bottom: 100, right: -40,
          child: Icon(Icons.all_inclusive_rounded, size: 200, color: Color(0x084C84FF)),
        ),
        Positioned(
          top: 350, right: 30,
          child: Opacity(
            opacity: 0.02,
            child: Transform.rotate(
              angle: 0.4,
              child: const Text("f(x) = ∫ sin(x) dx", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
        ),
        Positioned(
          bottom: 250, left: 40,
          child: Opacity(
            opacity: 0.02,
            child: Transform.rotate(
              angle: -0.2,
              child: const Text("E = mc²", 
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloatingElement extends StatefulWidget {
  final double? top, bottom, left, right;
  final Widget child;
  const _FloatingElement({this.top, this.bottom, this.left, this.right, required this.child});

  @override
  State<_FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<_FloatingElement> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top, bottom: widget.bottom, left: widget.left, right: widget.right,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.translate(offset: Offset(0, 15 * _ctrl.value), child: child);
        },
        child: widget.child,
      ),
    );
  }
}

class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final double slideOffset;
  const FadeInAnimation({super.key, required this.child, required this.delay, this.slideOffset = 20.0});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    // Start after the specified delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, widget.slideOffset * (1 - _anim.value)),
          child: Opacity(opacity: _anim.value, child: child),
        );
      },
      child: widget.child,
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  OnboardingData({required this.title, required this.description, required this.icon});
}
