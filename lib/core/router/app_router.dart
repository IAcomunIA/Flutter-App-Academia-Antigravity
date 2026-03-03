import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/presentation/screens/splash/splash_screen.dart';
import 'package:antigravity_quiz/presentation/screens/home/home_screen.dart';
import 'package:antigravity_quiz/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:antigravity_quiz/presentation/screens/categories/categories_screen.dart';
import 'package:antigravity_quiz/presentation/screens/quiz/quiz_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/categories',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
  ],
);
