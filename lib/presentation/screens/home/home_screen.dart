import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/space_card.dart';
import 'package:antigravity_quiz/presentation/widgets/xp_bar.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';
import 'package:antigravity_quiz/presentation/screens/mission/mission_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  final List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'IA Fundamentos',
      'subtitle': 'Cultura general: ML, Deep Learning, LLMs',
      'icon': Icons.smart_toy,
      'color': AppColors.catAI,
    },
    {
      'id': 2,
      'name': 'Arquitectura de 4 Capas',
      'subtitle': 'Directiva · Orquestador · Agentes · Observabilidad',
      'icon': Icons.layers,
      'color': AppColors.catAgents,
    },
    {
      'id': 3,
      'name': 'MCP y Reglas Globales',
      'subtitle': 'Model Context Protocol, logs y estándares',
      'icon': Icons.rule,
      'color': AppColors.catPython,
    },
    {
      'id': 4,
      'name': 'Agentes y Skills',
      'subtitle': 'Tipos de agentes, skills, workflows',
      'icon': Icons.engineering,
      'color': AppColors.catArch,
    },
    {
      'id': 5,
      'name': 'Orquestación Avanzada',
      'subtitle': 'Secuencial, paralela, pipeline, fan-out/in',
      'icon': Icons.account_tree,
      'color': AppColors.catProductivity,
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(progressProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ══════════════════════════════════════
            // ═══  SECCIÓN 1: PORTADA / HERO  ═══
            // ══════════════════════════════════════
            SizedBox(
              height: 480,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Fondo espacial
                  Image.asset(
                    'assets/images/antigravity-PRTADA-FONDO.png',
                    fit: BoxFit.cover,
                  ),
                  // Gradiente inferior para fundir con darkBg
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.darkBg.withOpacity(0.3),
                          AppColors.darkBg.withOpacity(0.85),
                          AppColors.darkBg,
                        ],
                        stops: const [0.0, 0.4, 0.75, 1.0],
                      ),
                    ),
                  ),
                  // Astronauta izquierdo flotante
                  AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      double floatY = _floatController.value * 14 - 7;
                      return Positioned(
                        left: 12,
                        top: 60 + floatY,
                        child: Transform.rotate(
                          angle: -0.18,
                          child: Image.asset(
                            'assets/images/un__astrnauta_personaje_antigravedad.png',
                            width: screenWidth * 0.26,
                          ),
                        ),
                      );
                    },
                  ),
                  // Astronauta derecho flotante
                  AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      double floatY = (1.0 - _floatController.value) * 16 - 8;
                      return Positioned(
                        right: 12,
                        top: 120 + floatY,
                        child: Transform.rotate(
                          angle: 0.15,
                          child: Image.asset(
                            'assets/images/astronauta_personaje_con_casco_flotando.png',
                            width: screenWidth * 0.22,
                          ),
                        ),
                      );
                    },
                  ),
                  // Contenido central glassmorphism
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.purple.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.cyan,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Academia Interactiva',
                                    style: TextStyle(
                                      color: AppColors.purpleLight,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Anti-Gravity',
                              style: AppTextStyles.heading1.copyWith(
                                fontSize: 34,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Builder(
                              builder: (context) {
                                final shader =
                                    const LinearGradient(
                                      colors: [
                                        AppColors.cyan,
                                        AppColors.purpleLight,
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(0, 0, 300, 25),
                                    );
                                return Text(
                                  'Orquestación de Agentes IA',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()..shader = shader,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Quiz · Drag & Drop · Comandos · Ordenar',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.keyboard_double_arrow_down,
                              color: AppColors.cyan.withOpacity(0.5),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════════
            // ═══  SECCIÓN 2: STATS DEL USUARIO  ═══
            // ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cardBg,
                      AppColors.surfaceBg.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.cyan, AppColors.purple],
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recluta Espacial',
                              style: AppTextStyles.heading2.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${userProgress.totalXP} XP Total',
                              style: const TextStyle(
                                color: AppColors.xpGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    XPBar(
                      progress: (userProgress.totalXP % 500) / 500,
                      currentXP: userProgress.totalXP,
                      nextLevelXP: ((userProgress.totalXP ~/ 500) + 1) * 500,
                    ),
                  ],
                ),
              ),
            ),

            // ══════════════════════════════════════
            // ═══ SECCIÓN 3: HEADER MISIONES    ═══
            // ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Misiones de la Academia'),
                  const SizedBox(height: 4),
                  const Text(
                    'Todos los módulos disponibles · 5 tipos de ejercicio',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════════
            // ═══ SECCIÓN 4: LISTA DE MÓDULOS   ═══
            // ═══ (TODOS ABIERTOS, SIN BLOQUEO) ═══
            // ══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
              child: Column(
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MissionScreen(
                              categoryId: cat['id'],
                              categoryName: cat['name'],
                              categoryColor: cat['color'],
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: SpaceCard(
                        borderColor: cat['color'],
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: (cat['color'] as Color).withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                cat['icon'],
                                color: cat['color'],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat['name'],
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    cat['subtitle'],
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      _tag(Icons.quiz, 'Quiz', cat['color']),
                                      const SizedBox(width: 5),
                                      _tag(
                                        Icons.swap_horiz,
                                        'D&D',
                                        cat['color'],
                                      ),
                                      const SizedBox(width: 5),
                                      _tag(Icons.terminal, 'Cmd', cat['color']),
                                      const SizedBox(width: 5),
                                      _tag(Icons.sort, 'Ord', cat['color']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: cat['color'],
                              size: 26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.cyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(title, style: AppTextStyles.heading2.copyWith(fontSize: 19)),
      ],
    );
  }
}
