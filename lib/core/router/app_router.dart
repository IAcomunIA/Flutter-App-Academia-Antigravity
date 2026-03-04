import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/presentation/screens/splash/splash_screen.dart';
import 'package:antigravity_quiz/presentation/screens/home/home_screen.dart';
import 'package:antigravity_quiz/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:antigravity_quiz/presentation/screens/categories/categories_screen.dart';
import 'package:antigravity_quiz/presentation/screens/quiz/quiz_screen.dart';
import 'package:antigravity_quiz/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:antigravity_quiz/presentation/screens/level_selector/level_selector_screen.dart';
import 'package:antigravity_quiz/presentation/screens/memory_game/memory_game_screen.dart';
import 'package:antigravity_quiz/presentation/screens/battle_mode/battle_mode_screen.dart';
import 'package:antigravity_quiz/presentation/screens/simulator/simulator_screen.dart';
import 'package:antigravity_quiz/presentation/screens/code_challenge/code_challenge_screen.dart';
import 'package:antigravity_quiz/presentation/screens/exercises/exercise_dispatch_screen.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainShell({super.key, required this.child, required this.currentIndex});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border(
            top: BorderSide(
              color: AppColors.borderColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          backgroundColor: AppColors.cardBg,
          selectedItemColor: AppColors.cyan,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/categories');
                break;
              case 2:
                context.go('/dashboard');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_filled),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Módulos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        int currentIndex = 0;
        final location = state.uri.toString();
        if (location.startsWith('/categories')) {
          currentIndex = 1;
        } else if (location.startsWith('/dashboard')) {
          currentIndex = 2;
        }
        return MainShell(currentIndex: currentIndex, child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
      ],
    ),

    // Rutas de Juego/Quiz fuera del Shell
    GoRoute(
      path: '/level-selector',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return LevelSelectorScreen(
          categoryId: extras['categoryId'],
          subcategoryId: extras['subcategoryId'],
          subcategoryName: extras['subcategoryName'],
          categoryColor: extras['categoryColor'],
        );
      },
    ),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(
      path: '/memory-game',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return MemoryGameScreen(
          categoryId: extras['categoryId'],
          categoryName: extras['categoryName'],
          categoryColor: extras['categoryColor'],
        );
      },
    ),
    GoRoute(
      path: '/battle-mode',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return BattleModeScreen(
          categoryId: extras['categoryId'],
          categoryName: extras['categoryName'],
          categoryColor: extras['categoryColor'],
        );
      },
    ),
    GoRoute(
      path: '/simulator',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return SimulatorScreen(
          categoryId: extras['categoryId'],
          categoryName: extras['categoryName'],
          categoryColor: extras['categoryColor'],
        );
      },
    ),
    GoRoute(
      path: '/code-challenge',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return CodeChallengeScreen(
          categoryId: extras['categoryId'],
          categoryName: extras['categoryName'],
          categoryColor: extras['categoryColor'],
        );
      },
    ),
    GoRoute(
      path: '/exercise',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return ExerciseDispatchScreen(
          exerciseType: extras['exerciseType'],
          data: extras['data'],
          categoryName: extras['categoryName'],
        );
      },
    ),
  ],
);
