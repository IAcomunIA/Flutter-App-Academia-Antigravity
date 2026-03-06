import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/space_card.dart';
import 'package:antigravity_quiz/presentation/widgets/xp_bar.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';
import 'package:antigravity_quiz/presentation/screens/level_selector/level_selector_screen.dart';
import 'package:antigravity_quiz/presentation/widgets/modals/pro_upgrade_modal.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'IA Fundamentos',
      'subtitle': 'Conceptos de IA',
      'progress': 0.75,
      'icon': Icons.smart_toy,
      'color': AppColors.catAI,
    },
    {
      'id': 2,
      'name': 'Agentes IA',
      'subtitle': 'Roles y Skills',
      'progress': 0.0,
      'icon': Icons.psychology,
      'color': AppColors.catAgents,
    },
    {
      'id': 3,
      'name': 'Arquitectura de 4 Capas',
      'subtitle': 'Orquestación',
      'progress': 0.0,
      'icon': Icons.layers,
      'color': AppColors.catArch,
    },
    {
      'id': 4,
      'name': 'Orquestación',
      'subtitle': 'Flujos Paralelos',
      'progress': 0.0,
      'icon': Icons.hub,
      'color': AppColors.catOrq,
    },
    {
      'id': 5,
      'name': 'MCP & Skills',
      'subtitle': 'Integración',
      'progress': 0.0,
      'icon': Icons.extension,
      'color': AppColors.catMCP,
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _showProModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ProUpgradeModal(),
    );
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
          children: [
            // ─────────────────────────────────────────
            // ═══  SECCIÓN 1: PORTADA PRINCIPAL  ═══
            // ─────────────────────────────────────────
            _buildHeroHeader(screenWidth),

            // ─────────────────────────────────────────
            // ═══  SECCIÓN 2: PERFIL DE RECLUTA   ═══
            // ─────────────────────────────────────────
            _buildUserStats(userProgress),

            // ─────────────────────────────────────────
            // ═══  SECCIÓN 3: MÓDULOS ACTIVOS   ═══
            // ─────────────────────────────────────────
            _buildActiveModules(userProgress),

            // ─────────────────────────────────────────
            // ═══  SECCIÓN 4: MISIÓN ACTUAL      ═══
            // ─────────────────────────────────────────
            _buildCurrentMission(),

            // ─────────────────────────────────────────
            // ═══  SECCIÓN 5: ENTRENAMIENTO      ═══
            // ─────────────────────────────────────────
            _buildTrainingGrid(),

            // ─────────────────────────────────────────
            // ═══  SECCIÓN 6: PRO EBOOK PACK     ═══
            // ─────────────────────────────────────────
            _buildProPackSection(),

            const SizedBox(height: 100), // Espacio para el nav footer
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(double screenWidth) {
    return SizedBox(
      height: 520,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fondo degradado
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 0.8,
                  colors: [AppColors.cyan.withOpacity(0.05), AppColors.darkBg],
                ),
              ),
            ),
          ),

          // Personaje animado
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Positioned(
                top:
                    60 + (sin(_floatController.value * 2 * pi) * 15).toDouble(),
                child:
                    Image.asset(
                          'assets/images/un__astrnauta_personaje_antigravedad.png',
                          height: 280,
                        )
                        .animate()
                        .fade(duration: 800.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
              );
            },
          ),

          // Títulos y tags
          Positioned(
            bottom: 40,
            child: Column(
              children: [
                Text(
                  'ANTI-GRAVITY',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 32,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'ACADEMY',
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 32,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ORQUESTACIÓN DE AGENTES IA',
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: 14,
                    color: AppColors.purpleLight,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                // Game Mode Tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGameTag('QUIZ'),
                    _buildGameTag('D&D'),
                    _buildGameTag('CMD'),
                    _buildGameTag('BATTLE'),
                    _buildGameTag('MEM'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTag(String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.cyan,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserStats(UserProgress progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar circular con nivel
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cyan, width: 2),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/un__astrnauta_personaje_antigravedad.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Lv 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RECLUTA ESPACIAL',
                        style: AppTextStyles.heading2.copyWith(fontSize: 16),
                      ),
                      Text(
                        '${progress.totalXP} XP Total',
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (progress.isPackProUnlocked)
                  const Icon(
                        Icons.workspace_premium,
                        color: AppColors.xpGold,
                        size: 24,
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds),
                const SizedBox(width: 8),
                const Icon(Icons.flash_on, color: AppColors.cyan, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PROGRESO DE NIVEL',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '150 / 500 XP',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.3,
                minHeight: 8,
                backgroundColor: AppColors.surfaceBg,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
              ),
            ),
            const SizedBox(height: 20),
            // Sub-stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSubStat('PRECISIÓN', '88%'),
                _buildSubStat('RACHA', '3 Días'),
                _buildSubStat('MISIONES', '12/40'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveModules(UserProgress progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('MÓDULOS DE APRENDIZAJE'),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'VER TODOS',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isLocked = !progress.unlockedCategoryIds.contains(
                  cat['id'],
                );
                return _buildModuleCard(cat, isLocked);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> cat, bool isLocked) {
    return InkWell(
      onTap: () {
        if (isLocked) {
          _showProModal();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LevelSelectorScreen(
              categoryId: cat['id'],
              subcategoryId: cat['id'],
              subcategoryName: cat['name'],
              categoryColor: cat['color'],
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLocked
                ? AppColors.borderColor.withOpacity(0.5)
                : AppColors.borderColor,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  cat['icon'],
                  color: isLocked ? AppColors.textMuted : cat['color'],
                  size: 20,
                ),
                const SizedBox(height: 12),
                Text(
                  cat['name'],
                  style: TextStyle(
                    color: isLocked ? AppColors.textMuted : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                const Spacer(),
                if (!isLocked)
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: cat['progress'] as double,
                            minHeight: 3,
                            backgroundColor: AppColors.surfaceBg,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              cat['color'] as Color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${((cat['progress'] as double) * 100).toInt()}%',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                if (isLocked)
                  const Text(
                    'MODULO BLOQUEADO',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            if (isLocked)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.lock, color: AppColors.textMuted, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildCurrentMission() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('MISIÓN ACTUAL'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'MISIÓN 01 (BÁSICO)',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'IA Fundamentos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Domina los pilares de la IA antes de empezar con los agentes.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LevelSelectorScreen(
                          categoryId: 1,
                          subcategoryId: 1,
                          subcategoryName: 'IA Fundamentos',
                          categoryColor: AppColors.catAI,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyan,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CONTINUAR MISIÓN',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.play_arrow, color: Colors.black),
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

  Widget _buildTrainingGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('ENTRENAMIENTO'),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildTrainingCard(
                'BATTLE MODE',
                'PvP Online',
                Icons.flash_on,
                Colors.redAccent,
              ),
              _buildTrainingCard(
                'MEMORY',
                'Refuerzo',
                Icons.extension,
                Colors.blueAccent,
              ),
              _buildTrainingCard(
                'SIMULADOR',
                'Terminal Pro',
                Icons.terminal,
                Colors.purpleAccent,
              ),
              _buildTrainingCard(
                'CODE ARENA',
                'Algoritmos',
                Icons.code,
                Colors.greenAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(
    String label,
    String sub,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: _showProModal,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sub,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProPackSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: InkWell(
        onTap: _showProModal,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.05),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: 20,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    'assets/images/libro-antigravity-con-postura-diferenteremovebg-preview.png',
                    height: 160,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EbookPack Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ACCESO DE POR VIDA',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProFeature('Plataforma Interactiva completada'),
                    _buildProFeature('Ebook "Arquitectura de Agentes" (PDF)'),
                    _buildProFeature('Workshop: 2 Horas de Video'),
                    _buildProFeature('Repo Base: Todos los Agentes IA'),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Regular: \$49',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '\$9.99',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'USD',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.5),
                            ),
                          ),
                          child: const Text(
                            'AHORRO 80%',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildProButton(),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Pago único. Sin suscripciones. Garantía 14 días.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
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
    );
  }

  Widget _buildProFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _showProModal,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cyan,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 20),
            SizedBox(width: 10),
            Text(
              'OBTENER PACK PRO',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
