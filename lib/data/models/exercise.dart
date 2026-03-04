import 'package:flutter/material.dart';

/// Tipos de ejercicio soportados en V2
enum ExerciseType {
  multipleChoice, // Quiz estándar A/B/C/D
  dragAndDrop, // Arrastrar y soltar elementos al lugar correcto
  multiSelect, // Seleccionar varias respuestas correctas
  commandInput, // Escribir un comando o respuesta corta
  ordering, // Ordenar pasos en secuencia correcta
  fillBlank, // Completar huecos en texto (V2)
  memory, // Juego de memoria: emparejar conceptos (V2)
  battle, // Modo battle: quiz rápido contra el tiempo (V2)
  simulator, // Simulador de agentes: construir flujos (V2)
  codeChallenge, // Reto de código: encontrar errores / completar (V2)
}

class Exercise {
  final int id;
  final int subcategoryId;
  final ExerciseType type;
  final String questionText;
  final String? hint;
  final String level; // basico|intermedio|avanzado (V2)

  // Para multipleChoice
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? correctOption;

  // Para multiSelect
  final List<String>? options;
  final List<int>? correctIndices;

  // Para dragAndDrop / ordering / flowOrder
  final List<String>? items;
  final List<String>? targets;
  final List<int>? correctOrder;

  // Para commandInput
  final List<String>? acceptedAnswers;

  // Para fillBlank (V2)
  final String? blankText; // Texto con _____ para completar
  final List<String>? wordBank; // Banco de palabras disponibles
  final List<String>? correctWords; // Respuestas correctas en orden

  // Para memory (V2)
  final List<String>? memoryPairs; // Pares concepto:definición

  // Para codeChallenge (V2)
  final String? codeSnippet; // Código a analizar
  final int? errorLine; // Línea del error (para modo "encontrar error")
  final List<String>? codeOptions; // Opciones de código (para completar)

  // Común
  final String explanation;
  final String difficulty;
  final int points;
  final int timeLimitSeconds;

  Exercise({
    required this.id,
    required this.subcategoryId,
    required this.type,
    required this.questionText,
    this.hint,
    this.level = 'basico',
    this.optionA,
    this.optionB,
    this.optionC,
    this.optionD,
    this.correctOption,
    this.options,
    this.correctIndices,
    this.items,
    this.targets,
    this.correctOrder,
    this.acceptedAnswers,
    this.blankText,
    this.wordBank,
    this.correctWords,
    this.memoryPairs,
    this.codeSnippet,
    this.errorLine,
    this.codeOptions,
    required this.explanation,
    this.difficulty = 'medio',
    this.points = 15,
    this.timeLimitSeconds = 30,
  });

  /// Timer según nivel V2
  static int getTimerForLevel(String level) {
    switch (level) {
      case 'basico':
        return 30;
      case 'intermedio':
        return 20;
      case 'avanzado':
        return 15;
      default:
        return 30;
    }
  }

  /// Multiplicador de XP según nivel V2
  static double getXPMultiplier(String level) {
    switch (level) {
      case 'basico':
        return 1.0;
      case 'intermedio':
        return 1.5;
      case 'avanzado':
        return 2.0;
      default:
        return 1.0;
    }
  }
}
