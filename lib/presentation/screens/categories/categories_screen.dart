import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/screens/level_selector/level_selector_screen.dart';
import 'package:antigravity_quiz/presentation/screens/memory_game/memory_game_screen.dart';
import 'package:antigravity_quiz/presentation/screens/battle_mode/battle_mode_screen.dart';
import 'package:antigravity_quiz/presentation/screens/simulator/simulator_screen.dart';
import 'package:antigravity_quiz/presentation/screens/code_challenge/code_challenge_screen.dart';

/// Pantalla de categorías V2 con 5 módulos y acceso a todos los modos
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const _categories = [
    _CategoryData(
      id: 1,
      name: 'IA Fundamentos',
      description: 'Base conceptual de IA para agentes Antigravity',
      icon: Icons.psychology,
      color: AppColors.catAI,
    ),
    _CategoryData(
      id: 2,
      name: 'Agentes IA — Metodología Antigravity',
      description: 'Qué es un agente, skills y autonomía',
      icon: Icons.smart_toy,
      color: AppColors.catAgents,
    ),
    _CategoryData(
      id: 3,
      name: 'Arquitectura de 4 Capas',
      description: 'Directiva, Orquestador, Agentes y Output',
      icon: Icons.layers,
      color: AppColors.catArch,
    ),
    _CategoryData(
      id: 4,
      name: 'Orquestación y Agentes Paralelos',
      description: 'Flujos, sincronización y coordinación',
      icon: Icons.account_tree,
      color: AppColors.catOrq,
    ),
    _CategoryData(
      id: 5,
      name: 'MCP, Skills y Reglas Globales',
      description: 'Model Context Protocol, recursos y standards',
      icon: Icons.rule,
      color: AppColors.catMCP,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('MÓDULOS', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cyan.withOpacity(0.1),
                  AppColors.purple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: AppColors.cyan, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antigravity Academy',
                        style: AppTextStyles.heading2.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '5 módulos · 3 niveles · 7 modos de juego',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Categorías
          ..._categories.map((cat) => _buildCategoryCard(context, cat)),

          const SizedBox(height: 24),

          // Sección: Modos especiales
          Text(
            'MODOS ESPECIALES',
            style: AppTextStyles.heading2.copyWith(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Grid de modos
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  context: context,
                  icon: Icons.whatshot,
                  title: 'Battle',
                  subtitle: '8s por pregunta',
                  color: AppColors.error,
                  onTap: () => _showCategorySelectorDialog(context, 'battle'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  context: context,
                  icon: Icons.grid_view,
                  title: 'Memoria',
                  subtitle: 'Pares concepto',
                  color: AppColors.purple,
                  onTap: () => _showCategorySelectorDialog(context, 'memory'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildModeCard(
                  context: context,
                  icon: Icons.account_tree,
                  title: 'Simulador',
                  subtitle: 'Flujos V2',
                  color: AppColors.catAgents,
                  onTap: () =>
                      _showCategorySelectorDialog(context, 'simulator'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildModeCard(
                  context: context,
                  icon: Icons.code,
                  title: 'Reto de Código',
                  subtitle: 'Bugs Agentes',
                  color: AppColors.catArch,
                  onTap: () => _showCategorySelectorDialog(context, 'code'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, _CategoryData cat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          context.push(
            '/level-selector',
            extra: {
              'categoryId': cat.id,
              'subcategoryId': cat.id,
              'subcategoryName': cat.name,
              'categoryColor': cat.color,
            },
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cat.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(cat.icon, color: cat.color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cat.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Mini indicador de niveles
                    Row(
                      children: [
                        _buildLevelDot('B', AppColors.success),
                        const SizedBox(width: 6),
                        _buildLevelDot('I', AppColors.warning),
                        const SizedBox(width: 6),
                        _buildLevelDot('A', AppColors.error),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: cat.color,
                        ),
                      ],
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

  Widget _buildLevelDot(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategorySelectorDialog(BuildContext context, String mode) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            mode == 'battle' ? '⚡ Selecciona módulo' : '🧠 Selecciona módulo',
            style: AppTextStyles.heading2.copyWith(fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories.map((cat) {
              return ListTile(
                leading: Icon(cat.icon, color: cat.color),
                title: Text(
                  cat.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  if (mode == 'battle') {
                    context.push(
                      '/battle-mode',
                      extra: {
                        'categoryId': cat.id,
                        'categoryName': cat.name,
                        'categoryColor': cat.color,
                      },
                    );
                  } else if (mode == 'memory') {
                    context.push(
                      '/memory-game',
                      extra: {
                        'categoryId': cat.id,
                        'categoryName': cat.name,
                        'categoryColor': cat.color,
                      },
                    );
                  } else if (mode == 'simulator') {
                    context.push(
                      '/simulator',
                      extra: {
                        'categoryId': cat.id,
                        'categoryName': cat.name,
                        'categoryColor': cat.color,
                      },
                    );
                  } else if (mode == 'code') {
                    context.push(
                      '/code-challenge',
                      extra: {
                        'categoryId': cat.id,
                        'categoryName': cat.name,
                        'categoryColor': cat.color,
                      },
                    );
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CategoryData {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const _CategoryData({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
