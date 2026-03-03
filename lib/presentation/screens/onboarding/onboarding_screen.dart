import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/space_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Bienvenido Recluta',
      'desc':
          'Estás a punto de entrar en la dimensión de los agentes autónomos.',
      'image': 'assets/images/un__astrnauta_personaje_antigravedad.png',
    },
    {
      'title': 'Arquitectura de 4 Capas',
      'desc': 'Domina el flujo Maestro, Orquestador, Agentes y Salida.',
      'image': 'assets/images/temario_arquitectura_capas.png',
    },
    {
      'title': 'Gana XP y Medallas',
      'desc': 'Demuestra tus conocimientos y asciende de rango en la academia.',
      'image': 'assets/images/tres_agentes_astronautas_con_casco.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (v) => setState(() => _currentPage = v),
            itemCount: _pages.length,
            itemBuilder: (context, i) => _buildPage(i),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                SpaceButton(
                  label: _currentPage == _pages.length - 1
                      ? 'COMENZAR'
                      : 'SIGUIENTE',
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    } else {
                      context.go('/');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int i) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(_pages[i]['image']!, height: 300),
          const SizedBox(height: 40),
          Text(
            _pages[i]['title']!,
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            _pages[i]['desc']!,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.cyan : AppColors.textMuted,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
