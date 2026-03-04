import 'dart:math';
import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget para el juego de memoria: emparejar conceptos ↔ definiciones (V2)
class MemoryGameWidget extends StatefulWidget {
  final List<MapEntry<String, String>> pairs; // concepto → definición
  final Function(bool allMatched, int errors, int timeSeconds) onComplete;

  const MemoryGameWidget({
    super.key,
    required this.pairs,
    required this.onComplete,
  });

  @override
  State<MemoryGameWidget> createState() => _MemoryGameWidgetState();
}

class _MemoryGameWidgetState extends State<MemoryGameWidget>
    with TickerProviderStateMixin {
  late List<_MemoryCard> cards;
  int? firstFlippedIndex;
  int? secondFlippedIndex;
  bool isChecking = false;
  int matchedPairs = 0;
  int errorCount = 0;
  int comboCount = 0;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch()..start();
    _initializeCards();
  }

  void _initializeCards() {
    cards = [];
    for (int i = 0; i < widget.pairs.length; i++) {
      // Añadir concepto
      cards.add(
        _MemoryCard(
          id: i,
          text: widget.pairs[i].key,
          pairId: i,
          isConcepto: true,
        ),
      );
      // Añadir definición
      cards.add(
        _MemoryCard(
          id: i + widget.pairs.length,
          text: widget.pairs[i].value,
          pairId: i,
          isConcepto: false,
        ),
      );
    }
    cards.shuffle(Random());
  }

  void _onCardTap(int index) {
    if (isChecking || cards[index].isMatched || cards[index].isFlipped) return;

    setState(() {
      cards[index].isFlipped = true;

      if (firstFlippedIndex == null) {
        firstFlippedIndex = index;
      } else {
        secondFlippedIndex = index;
        isChecking = true;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    final card1 = cards[firstFlippedIndex!];
    final card2 = cards[secondFlippedIndex!];

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        if (card1.pairId == card2.pairId &&
            card1.isConcepto != card2.isConcepto) {
          // ¡Match correcto!
          card1.isMatched = true;
          card2.isMatched = true;
          matchedPairs++;
          comboCount++;
        } else {
          // No match
          card1.isFlipped = false;
          card2.isFlipped = false;
          errorCount++;
          comboCount = 0;
        }

        firstFlippedIndex = null;
        secondFlippedIndex = null;
        isChecking = false;

        // ¿Completado?
        if (matchedPairs == widget.pairs.length) {
          stopwatch.stop();
          widget.onComplete(true, errorCount, stopwatch.elapsed.inSeconds);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header: stats
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                'Pares',
                '$matchedPairs/${widget.pairs.length}',
                AppColors.success,
              ),
              _buildStat('Errores', '$errorCount', AppColors.error),
              if (comboCount >= 2)
                _buildStat('¡Combo!', '×$comboCount', AppColors.xpGold),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Grid de cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildCard(int index) {
    final card = cards[index];

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? AppColors.success.withOpacity(0.15)
              : card.isFlipped
              ? (card.isConcepto
                    ? AppColors.cyan.withOpacity(0.15)
                    : AppColors.purple.withOpacity(0.15))
              : AppColors.surfaceBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.isMatched
                ? AppColors.success
                : card.isFlipped
                ? (card.isConcepto ? AppColors.cyan : AppColors.purple)
                : AppColors.borderColor,
            width: card.isMatched ? 2 : 1,
          ),
          boxShadow: card.isMatched
              ? [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: card.isFlipped || card.isMatched
                ? Text(
                    card.text,
                    style: TextStyle(
                      color: card.isMatched
                          ? AppColors.success
                          : AppColors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  )
                : Icon(
                    Icons.help_outline,
                    color: AppColors.textMuted,
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}

class _MemoryCard {
  final int id;
  final String text;
  final int pairId;
  final bool isConcepto;
  bool isFlipped;
  bool isMatched;

  _MemoryCard({
    required this.id,
    required this.text,
    required this.pairId,
    required this.isConcepto,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
