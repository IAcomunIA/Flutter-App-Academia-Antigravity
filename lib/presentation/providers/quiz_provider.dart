import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/question.dart';
import '../../data/repositories/quiz_repository.dart';

final quizRepositoryProvider = Provider((ref) => QuizRepository());

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final bool isFinished;
  final Map<int, String> answers;

  QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.isFinished = false,
    this.answers = const {},
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    bool? isFinished,
    Map<int, String>? answers,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      isFinished: isFinished ?? this.isFinished,
      answers: answers ?? this.answers,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final QuizRepository _repository;

  QuizNotifier(this._repository) : super(QuizState(questions: []));

  Future<void> loadQuiz(int subcategoryId) async {
    final questions = await _repository.getQuestions(subcategoryId);
    state = QuizState(questions: questions);
  }

  void submitAnswer(String option) {
    var newAnswers = Map<int, String>.from(state.answers);
    newAnswers[state.currentIndex] = option;
    
    if (state.currentIndex + 1 < state.questions.length) {
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: state.currentIndex + 1,
      );
    } else {
      state = state.copyWith(
        answers: newAnswers,
        isFinished: true,
      );
    }
  }
}

final quizProvider = StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.watch(quizRepositoryProvider));
});
