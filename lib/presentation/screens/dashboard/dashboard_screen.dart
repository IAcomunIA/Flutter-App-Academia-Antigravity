import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/repositories/user_repository.dart';
import 'package:antigravity_quiz/data/repositories/quiz_repository.dart';
import 'package:antigravity_quiz/data/models/quiz_result.dart';
import 'package:antigravity_quiz/presentation/widgets/xp_bar.dart';

/// Dashboard V2 — Estadísticas, progreso, badges y gráfica semanal
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserRepository _userRepo = UserRepository();
  final QuizRepository _quizRepo = QuizRepository();

  Map<String, dynamic>? userData;
  int quizCount = 0;
  double accuracy = 0.0;
  List<QuizResult> recentHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _userRepo.getCurrentUser();
    final count = user != null ? await _userRepo.getQuizCount(user['id']) : 0;
    final acc = user != null
        ? await _userRepo.getGlobalAccuracy(user['id'])
        : 0.0;
    final history = user != null
        ? await _quizRepo.getQuizHistory(user['id'], limit: 10)
        : <QuizResult>[];

    if (mounted) {
      setState(() {
        userData = user;
        quizCount = count;
        accuracy = acc;
        recentHistory = history;
        isLoading = false;
      });
    }
  }

  String get _userName => userData?['name'] ?? 'Astronauta';
  int get _userXP => userData?['xp'] ?? 0;
  int get _userLevel => userData?['level'] ?? 1;
  int get _userStreak => userData?['streak'] ?? 0;
  int get _bestStreak => userData?['best_streak'] ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.cyan),
            )
          : CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppColors.darkBg,
                  pinned: true,
                  expandedHeight: 0,
                  title: Text('DASHBOARD', style: AppTextStyles.heading2),
                  centerTitle: false,
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ─── Sección 1: Perfil + Nivel ───
                      _buildProfileSection(),
                      const SizedBox(height: 24),

                      // ─── Sección 2: Estadísticas Globales ───
                      _buildSectionTitle('ESTADÍSTICAS'),
                      const SizedBox(height: 12),
                      _buildStatsGrid(),
                      const SizedBox(height: 24),

                      // ─── Sección 3: Progreso por Categoría ───
                      _buildSectionTitle('PROGRESO POR MÓDULO'),
                      const SizedBox(height: 12),
                      _buildCategoryProgress(),
                      const SizedBox(height: 24),

                      // ─── Sección 4: Badges ───
                      _buildSectionTitle(
                        'INSIGNIAS (${_earnedBadgesCount}/16)',
                      ),
                      const SizedBox(height: 12),
                      _buildBadgesGrid(),
                      const SizedBox(height: 24),

                      // ─── Sección 5: Historial ───
                      if (recentHistory.isNotEmpty) ...[
                        _buildSectionTitle('HISTORIAL RECIENTE'),
                        const SizedBox(height: 12),
                        ...recentHistory.map(_buildHistoryItem),
                      ],

                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.heading2.copyWith(
        fontSize: 14,
        color: AppColors.textSecondary,
        letterSpacing: 1.5,
      ),
    );
  }

  // ─── PERFIL ───
  Widget _buildProfileSection() {
    final levelName = UserRepository.getLevelName(_userLevel);
    final nextLevelXP = UserRepository.getXPForNextLevel(_userLevel);
    final xpProgress = _userXP / nextLevelXP;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cyan.withOpacity(0.08),
            AppColors.purple.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientCyan,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Level chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Nivel $_userLevel — $levelName',
                        style: const TextStyle(
                          color: AppColors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_userXP XP',
                    style: const TextStyle(
                      color: AppColors.xpGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$nextLevelXP XP',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: xpProgress.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: AppColors.surfaceBg,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.xpGold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── STATS GRID ───
  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.track_changes,
            label: 'Precisión',
            value: '${accuracy.toStringAsFixed(0)}%',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.quiz,
            label: 'Quizzes',
            value: '$quizCount',
            color: AppColors.cyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department,
            label: 'Racha',
            value: '$_userStreak 🔥',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ─── PROGRESO POR CATEGORÍA ───
  Widget _buildCategoryProgress() {
    final categories = [
      {'name': 'IA Fundamentos', 'color': AppColors.catAI, 'progress': 0.0},
      {'name': 'Agentes IA', 'color': AppColors.catAgents, 'progress': 0.0},
      {
        'name': 'Arquitectura 4 Capas',
        'color': AppColors.catArch,
        'progress': 0.0,
      },
      {'name': 'Orquestación', 'color': AppColors.catOrq, 'progress': 0.0},
      {'name': 'MCP y Reglas', 'color': AppColors.catMCP, 'progress': 0.0},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: cat['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    cat['name'] as String,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: cat['progress'] as double,
                      minHeight: 6,
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
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── BADGES ───
  int get _earnedBadgesCount => 0; // Se actualiza con datos reales

  static const _allBadges = [
    {
      'id': 'primer_despegue',
      'name': 'Primer Despegue',
      'icon': Icons.rocket_launch,
    },
    {
      'id': 'punteria_perfecta',
      'name': 'Puntería Perfecta',
      'icon': Icons.military_tech,
    },
    {
      'id': 'en_llamas',
      'name': 'En Llamas',
      'icon': Icons.local_fire_department,
    },
    {'id': 'explorador', 'name': 'Explorador', 'icon': Icons.explore},
    {'id': 'maestro_ia', 'name': 'Maestro IA', 'icon': Icons.psychology},
    {'id': 'velocista', 'name': 'Velocista', 'icon': Icons.speed},
    {
      'id': 'perfeccionista',
      'name': 'Perfeccionista',
      'icon': Icons.workspace_premium,
    },
    {'id': 'comandante', 'name': 'Comandante', 'icon': Icons.stars},
    {
      'id': 'arquitecto_digital',
      'name': 'Arquitecto de 4 Capas',
      'icon': Icons.architecture,
    },
    {'id': 'orquestador', 'name': 'Maestro Orquestador', 'icon': Icons.hub},
    {'id': 'maestro_memoria', 'name': 'Maestro Memoria', 'icon': Icons.memory},
    {
      'id': 'guerrero_battle',
      'name': 'Guerrero Battle',
      'icon': Icons.whatshot,
    },
    {'id': 'mcp_master', 'name': 'Dominio MCP', 'icon': Icons.code},
    {
      'id': 'simulador_experto',
      'name': 'Simulador Experto',
      'icon': Icons.precision_manufacturing,
    },
    {'id': 'maratonista', 'name': 'Maratonista', 'icon': Icons.directions_run},
    {
      'id': 'leyenda_antigravity',
      'name': 'Leyenda',
      'icon': Icons.emoji_events,
    },
  ];

  Widget _buildBadgesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _allBadges.length,
      itemBuilder: (context, index) {
        final badge = _allBadges[index];
        final isEarned = false; // Se conecta con datos reales

        return GestureDetector(
          onTap: () => _showBadgeInfo(badge['name'] as String, isEarned),
          child: Container(
            decoration: BoxDecoration(
              color: isEarned
                  ? AppColors.xpGold.withOpacity(0.1)
                  : AppColors.surfaceBg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isEarned
                    ? AppColors.xpGold.withOpacity(0.5)
                    : AppColors.borderColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isEarned ? badge['icon'] as IconData : Icons.lock,
                  size: 28,
                  color: isEarned ? AppColors.xpGold : AppColors.textMuted,
                ),
                const SizedBox(height: 6),
                Text(
                  badge['name'] as String,
                  style: TextStyle(
                    color: isEarned
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBadgeInfo(String name, bool isEarned) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(name, style: AppTextStyles.heading2.copyWith(fontSize: 16)),
        content: Text(
          isEarned
              ? '¡Felicidades! Has desbloqueado esta insignia.'
              : 'Sigue jugando para desbloquear esta insignia.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: AppColors.cyan)),
          ),
        ],
      ),
    );
  }

  // ─── HISTORIAL ───
  Widget _buildHistoryItem(QuizResult result) {
    final starsDisplay =
        '★' * result.starsEarned + '☆' * (3 - result.starsEarned);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Score circular
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: result.percentage >= 70
                  ? AppColors.success.withOpacity(0.15)
                  : AppColors.error.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${result.percentage.toInt()}%',
                style: TextStyle(
                  color: result.percentage >= 70
                      ? AppColors.success
                      : AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz ${result.level.toUpperCase()}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${result.correctCount}/${result.totalQuestions} correctas',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                starsDisplay,
                style: const TextStyle(
                  color: AppColors.starColor,
                  fontSize: 14,
                ),
              ),
              Text(
                '+${result.xpEarned} XP',
                style: const TextStyle(
                  color: AppColors.xpGold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
