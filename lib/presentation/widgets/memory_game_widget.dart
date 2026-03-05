import 'dart:math';
import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Modo de visualización del juego de memoria
enum MemoryGameMode {
  icon, // Básico: solo iconos/emojis visuales
  mixed, // Intermedio: un lado icono, otro texto
  text, // Avanzado: concepto ↔ definición (texto puro)
}

/// Widget para el juego de memoria con 3 modos
class MemoryGameWidget extends StatefulWidget {
  final List<MemoryPairData> pairs;
  final MemoryGameMode mode;
  final Function(bool allMatched, int errors, int timeSeconds) onComplete;

  const MemoryGameWidget({
    super.key,
    required this.pairs,
    required this.onComplete,
    this.mode = MemoryGameMode.text,
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
      final pair = widget.pairs[i];

      switch (widget.mode) {
        case MemoryGameMode.icon:
          // Básico: Dos cartas por par, ambas con icono idéntico
          // El usuario empareja dos iconos iguales
          cards.add(
            _MemoryCard(
              id: i * 2,
              pairId: i,
              isConcepto: true,
              icon: pair.icon,
              displayText: null,
              cardColor: pair.color ?? AppColors.cyan,
            ),
          );
          cards.add(
            _MemoryCard(
              id: i * 2 + 1,
              pairId: i,
              isConcepto: false,
              icon: pair.icon,
              displayText: null,
              cardColor: pair.color ?? AppColors.cyan,
            ),
          );
          break;

        case MemoryGameMode.mixed:
          // Intermedio: Una carta con icono, otra con texto
          cards.add(
            _MemoryCard(
              id: i * 2,
              pairId: i,
              isConcepto: true,
              icon: pair.icon,
              displayText: null,
              cardColor: pair.color ?? AppColors.purple,
            ),
          );
          cards.add(
            _MemoryCard(
              id: i * 2 + 1,
              pairId: i,
              isConcepto: false,
              icon: null,
              displayText: pair.definition,
              cardColor: pair.color ?? AppColors.purple,
            ),
          );
          break;

        case MemoryGameMode.text:
          // Avanzado: concepto ↔ definición (texto puro)
          cards.add(
            _MemoryCard(
              id: i * 2,
              pairId: i,
              isConcepto: true,
              icon: null,
              displayText: pair.concept,
              cardColor: pair.color ?? AppColors.cyan,
            ),
          );
          cards.add(
            _MemoryCard(
              id: i * 2 + 1,
              pairId: i,
              isConcepto: false,
              icon: null,
              displayText: pair.definition,
              cardColor: pair.color ?? AppColors.purple,
            ),
          );
          break;
      }
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

  String _getModeLabel() {
    switch (widget.mode) {
      case MemoryGameMode.icon:
        return '🎨 Modo Visual';
      case MemoryGameMode.mixed:
        return '🔀 Modo Mixto';
      case MemoryGameMode.text:
        return '📝 Modo Texto';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcular columnas según cantidad de cartas
    int crossAxisCount = cards.length <= 8 ? 3 : 4;

    return Column(
      children: [
        // Mode badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.purple.withOpacity(0.3)),
          ),
          child: Text(
            _getModeLabel(),
            style: const TextStyle(
              color: AppColors.purpleLight,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: widget.mode == MemoryGameMode.icon ? 1.0 : 0.75,
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
    final isRevealed = card.isFlipped || card.isMatched;

    return GestureDetector(
      onTap: () => _onCardTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isMatched
              ? AppColors.success.withOpacity(0.15)
              : card.isFlipped
              ? card.cardColor.withOpacity(0.12)
              : AppColors.surfaceBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: card.isMatched
                ? AppColors.success
                : card.isFlipped
                ? card.cardColor
                : AppColors.borderColor,
            width: card.isMatched || card.isFlipped ? 2 : 1,
          ),
          boxShadow: card.isMatched
              ? [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : card.isFlipped
              ? [
                  BoxShadow(
                    color: card.cardColor.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: isRevealed
                ? _buildRevealedContent(card)
                : _buildHiddenContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.help_outline,
            color: AppColors.textMuted,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '?',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedContent(_MemoryCard card) {
    final color = card.isMatched ? AppColors.success : card.cardColor;

    // Si la carta tiene icono, mostrar icono
    if (card.icon != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            card.icon,
            size: widget.mode == MemoryGameMode.icon ? 36 : 30,
            color: color,
          ),
          if (widget.mode == MemoryGameMode.icon) ...[
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      );
    }

    // Si la carta tiene texto, mostrar texto
    return Text(
      card.displayText ?? '',
      style: TextStyle(
        color: color,
        fontSize: card.isConcepto ? 11 : 10,
        fontWeight: card.isConcepto ? FontWeight.bold : FontWeight.w500,
      ),
      textAlign: TextAlign.center,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Datos de un par para el juego de memoria
class MemoryPairData {
  final String concept;
  final String definition;
  final IconData? icon;
  final Color? color;

  const MemoryPairData({
    required this.concept,
    required this.definition,
    this.icon,
    this.color,
  });
}

class _MemoryCard {
  final int id;
  final int pairId;
  final bool isConcepto;
  final IconData? icon;
  final String? displayText;
  final Color cardColor;
  bool isFlipped;
  bool isMatched;

  _MemoryCard({
    required this.id,
    required this.pairId,
    required this.isConcepto,
    this.icon,
    this.displayText,
    required this.cardColor,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
