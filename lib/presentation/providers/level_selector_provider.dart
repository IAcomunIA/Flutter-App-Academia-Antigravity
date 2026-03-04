import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/level_progress.dart';
import '../../data/repositories/quiz_repository.dart';

/// Estado del selector de nivel V2
class LevelSelectorState {
  final int subcategoryId;
  final String selectedLevel;
  final LevelProgress? basicProgress;
  final LevelProgress? intermediateProgress;
  final LevelProgress? advancedProgress;
  final bool isLoading;

  LevelSelectorState({
    required this.subcategoryId,
    this.selectedLevel = 'basico',
    this.basicProgress,
    this.intermediateProgress,
    this.advancedProgress,
    this.isLoading = true,
  });

  bool get isIntermediateUnlocked =>
      LevelProgress.isLevelUnlocked('intermedio', basicProgress);

  bool get isAdvancedUnlocked =>
      LevelProgress.isLevelUnlocked('avanzado', intermediateProgress);

  LevelSelectorState copyWith({
    int? subcategoryId,
    String? selectedLevel,
    LevelProgress? basicProgress,
    LevelProgress? intermediateProgress,
    LevelProgress? advancedProgress,
    bool? isLoading,
  }) {
    return LevelSelectorState(
      subcategoryId: subcategoryId ?? this.subcategoryId,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      basicProgress: basicProgress ?? this.basicProgress,
      intermediateProgress: intermediateProgress ?? this.intermediateProgress,
      advancedProgress: advancedProgress ?? this.advancedProgress,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LevelSelectorNotifier extends StateNotifier<LevelSelectorState> {
  final QuizRepository _repository;
  int _subcategoryId;

  LevelSelectorNotifier(this._repository, int subcategoryId)
    : _subcategoryId = subcategoryId,
      super(LevelSelectorState(subcategoryId: subcategoryId)) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    debugPrint('LEVEL PROVIDER: Cargando progreso para subcategoryId: $_subcategoryId');
    final progressMap = await _repository.getAllLevelProgress(1, _subcategoryId);
    
    debugPrint('LEVEL PROVIDER: basic stars = ${progressMap['basico']?.stars}');
    debugPrint('LEVEL PROVIDER: intermediate stars = ${progressMap['intermedio']?.stars}');
    
    state = LevelSelectorState(
      subcategoryId: _subcategoryId,
      basicProgress: progressMap['basico'],
      intermediateProgress: progressMap['intermedio'],
      advancedProgress: progressMap['avanzado'],
      isLoading: false,
    );
  }

  void selectLevel(String level) {
    if (level == 'basico' ||
        (level == 'intermedio' && state.isIntermediateUnlocked) ||
        (level == 'avanzado' && state.isAdvancedUnlocked)) {
      state = state.copyWith(selectedLevel: level);
    }
  }

  Future<void> refresh() async {
    await _loadProgress();
  }
}

/// Provider family: uno por cada subcategoría
final levelSelectorProvider = StateNotifierProvider
    .family<LevelSelectorNotifier, LevelSelectorState, int>((
      ref,
      subcategoryId,
    ) {
      final repository = QuizRepository();
      return LevelSelectorNotifier(repository, subcategoryId);
    });
