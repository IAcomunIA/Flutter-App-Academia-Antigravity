import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A18),
      body: Stack(
        children: [
          // Background Stars
          Positioned.fill(child: _buildBackgroundStars()),

          PageView(
            controller: _pageController,
            onPageChanged: (v) => setState(() => _currentPage = v),
            children: [_buildSlide1(), _buildSlide2(), _buildSlide3()],
          ),

          // Top Header (Logo & Season)
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child:
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [_buildLogo(), _buildSeasonChip()],
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: -0.2),
          ),

          // Bottom Navigation (Dots & Buttons)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child:
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Indicators
                        Row(
                          children: List.generate(
                            3,
                            (index) => _buildIndicator(index),
                          ),
                        ),

                        // Jump/Next Actions
                        Row(
                          children: [
                            if (_currentPage < 2)
                              TextButton(
                                onPressed: () => context.go('/'),
                                child: Text(
                                  'SALTAR',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            const SizedBox(width: 12),
                            _buildActionButton(),
                          ],
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms)
                    .slideY(begin: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
        color: AppColors.cyan.withOpacity(0.05),
      ),
      child: const Center(
        child: Text(
          'A',
          style: TextStyle(
            color: AppColors.cyan,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Orbitron',
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🛸 ', style: TextStyle(fontSize: 10)),
          Text(
            'TEMPORADA 1',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontFamily: 'Orbitron',
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
      margin: const EdgeInsets.only(right: 8),
      height: 4,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.cyan : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(2),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildActionButton() {
    bool isLast = _currentPage == 2;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_currentPage < 2) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutQuad,
            );
          } else {
            context.go('/');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLast ? '¡COMENZAR MI MISIÓN!' : 'SIGUIENTE',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontFamily: 'Orbitron',
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 16),
          ],
        ),
      ),
    );
  }

  // SLIDE 1: WELCOME RECRUIT
  Widget _buildSlide1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Mascot Circle
          Stack(
            alignment: Alignment.center,
            children: [
              // Glow circles
              Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.cyan.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.1, 1.1),
                    duration: 2000.ms,
                  ),

              // Decorative circle border
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyan.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),

              // Mascot Image
              Image.asset(
                'assets/images/un__astrnauta_personaje_antigravedad.png',
                height: 200,
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),

              // Floating small element (as seen in design)
              Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    'assets/images/un__astrnauta_personaje_antigravedad.png', // Fallback icon
                    height: 24,
                  ),
                ),
              ).animate().fadeIn(duration: 800.ms, delay: 400.ms).scale(),
            ],
          ),

          const SizedBox(height: 60),

          // Badge
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
                ),
                child: const Text(
                  'ACADEMIA DE AGENTES IA · NIVEL 0',
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: 'Orbitron',
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 300.ms)
              .slideY(begin: 0.2),

          const SizedBox(height: 24),

          // Title
          Column(
                children: [
                  const Text(
                    'BIENVENIDO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      fontFamily: 'Orbitron',
                    ),
                  ),
                  Text(
                    'RECLUTA',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontFamily: 'Orbitron',
                      shadows: [
                        Shadow(
                          color: AppColors.cyan.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 500.ms)
              .scaleY(begin: 0.9),

          const SizedBox(height: 20),

          // Subtext
          Text(
            'Estás a punto de entrar en la dimensión de los Agentes Autónomos.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
        ],
      ),
    );
  }

  // SLIDE 2: 4 LAYERS ARCHITECTURE
  Widget _buildSlide2() {
    return Column(
      children: [
        const SizedBox(height: 140),

        // Methodology Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.purple.withOpacity(0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flash_on, color: AppColors.purpleLight, size: 12),
              SizedBox(width: 6),
              Text(
                'METODOLOGÍA ANTIGRAVITY',
                style: TextStyle(
                  color: AppColors.purpleLight,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontFamily: 'Orbitron',
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2),

        const SizedBox(height: 40),

        // Visual Stack of Layers
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Connecting Lines
              Positioned(
                top: 40,
                bottom: 40,
                child: Container(
                  width: 2,
                  color: AppColors.cyan.withOpacity(0.1),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _build3DLayer('OUTPUT', AppColors.cyan, 1),
                  const SizedBox(height: 20),
                  _build3DLayer('AGENTES', AppColors.purpleLight, 2),
                  const SizedBox(height: 20),
                  _build3DLayer('ORQUESTADOR', const Color(0xFFF59E0B), 3),
                  const SizedBox(height: 20),
                  _build3DLayer('DIRECTIVA', const Color(0xFF10B981), 4),
                ],
              ),

              // Little Mascot overlapping
              Positioned(
                right: 30,
                bottom: 150,
                child:
                    Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/un__astrnauta_personaje_antigravedad.png',
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(begin: -10, end: 10, duration: 1500.ms),
              ),
            ],
          ),
        ),

        // Bottom Info Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1526).withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 110),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '🏗️ ARQUITECTURA CORE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Arquitectura de 4 Capas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Nuestra metodología orquestada garantiza que cada agente de IA trabaje en armonía para resultados superiores.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Chips Grid
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSmallChip('DIRECTIVA', const Color(0xFF10B981)),
                  _buildSmallChip('ORQUESTADOR', const Color(0xFFF59E0B)),
                  _buildSmallChip('AGENTES', AppColors.purpleLight),
                  _buildSmallChip('OUTPUT', AppColors.cyan),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms).moveY(begin: 100, end: 0),
      ],
    );
  }

  Widget _build3DLayer(String label, Color color, int index) {
    return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-0.5)
            ..rotateY(0.1),
          alignment: Alignment.center,
          child: Container(
            width: 220,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 14,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (index * 150).ms)
        .slideX(begin: index % 2 == 0 ? 0.2 : -0.2);
  }

  Widget _buildSmallChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
        ],
      ),
    );
  }

  // SLIDE 3: XP & PROGRESSION
  Widget _buildSlide3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFF59E0B).withOpacity(0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, color: Color(0xFFF59E0B), size: 14),
                SizedBox(width: 8),
                Text(
                  'SISTEMA DE PROGRESIÓN',
                  style: TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          const SizedBox(height: 40),

          // XP & Floating elements
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Floating icons
                _buildFloatingIcon(
                  Icons.workspace_premium,
                  const Color(0xFFF59E0B),
                  -80,
                  -80,
                ),
                _buildFloatingIcon(Icons.whatshot, Colors.deepOrange, 80, -60),
                _buildFloatingIcon(Icons.flash_on, AppColors.cyan, -90, 40),
                _buildFloatingIcon(Icons.bar_chart, Colors.white, 90, 50),

                // XP Text
                Text(
                  'XP',
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Orbitron',
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: [Colors.white, Color(0xFFF59E0B)],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 100)),
                    shadows: [
                      Shadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.5),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),

                // Mascot & Badge
                Positioned(
                  bottom: -20,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/un__astrnauta_personaje_antigravedad.png',
                        height: 120,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cyan.withOpacity(0.5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.flash_on,
                              color: AppColors.cyan,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'SUBE DE RANGO',
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              ],
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            'GANA XP Y\nMEDALLAS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: 'Orbitron',
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).scaleY(begin: 0.9),

          const SizedBox(height: 32),

          // Mini-Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMiniStat('900', 'PREGUNTAS', const Color(0xFFF59E0B)),
              _buildMiniStat('16', 'INSIGNIAS', AppColors.purpleLight),
              _buildMiniStat('10', 'RANGOS', AppColors.cyan),
            ],
          ).animate().fadeIn(delay: 500.ms),

          const Spacer(),

          // Footer Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ya tengo cuenta · ',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              Text(
                'Iniciar sesión',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, double x, double y) {
    return Positioned(
          left: 150 + x,
          top: 150 + y,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.2), blurRadius: 10),
              ],
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: -8,
          end: 8,
          duration: (2000 + math.Random().nextInt(1000)).ms,
        );
  }

  Widget _buildMiniStat(String val, String label, Color color) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Orbitron',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 8,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundStars() {
    return Stack(
      children: List.generate(30, (i) {
        final random = math.Random();
        return Positioned(
          left: random.nextDouble() * 400,
          top: random.nextDouble() * 800,
          child:
              Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        random.nextDouble() * 0.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .fadeIn(duration: (1000 + random.nextInt(2000)).ms),
        );
      }),
    );
  }
}
