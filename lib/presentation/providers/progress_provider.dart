import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProgress {
  final Set<int> unlockedCategoryIds;
  final int totalXP;
  final bool isPackProUnlocked;

  UserProgress({
    required this.unlockedCategoryIds,
    this.totalXP = 150,
    this.isPackProUnlocked = false,
  });

  UserProgress copyWith({
    Set<int>? unlockedCategoryIds,
    int? totalXP,
    bool? isPackProUnlocked,
  }) {
    return UserProgress(
      unlockedCategoryIds: unlockedCategoryIds ?? this.unlockedCategoryIds,
      totalXP: totalXP ?? this.totalXP,
      isPackProUnlocked: isPackProUnlocked ?? this.isPackProUnlocked,
    );
  }
}

class ProgressNotifier extends StateNotifier<UserProgress> {
  ProgressNotifier() : super(UserProgress(unlockedCategoryIds: {1}));

  void unlockCategory(int id) {
    state = state.copyWith(
      unlockedCategoryIds: {...state.unlockedCategoryIds, id},
    );
  }

  void unlockPackPro() {
    state = state.copyWith(
      isPackProUnlocked: true,
      // Al desbloquear Pack Pro, abrimos todos los IDs de categorías (1 al 5)
      unlockedCategoryIds: {1, 2, 3, 4, 5},
    );
  }

  void addXP(int xp) {
    state = state.copyWith(totalXP: state.totalXP + xp);
  }

  bool isUnlocked(int id) => state.unlockedCategoryIds.contains(id);
}

final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((
  ref,
) {
  return ProgressNotifier();
});
