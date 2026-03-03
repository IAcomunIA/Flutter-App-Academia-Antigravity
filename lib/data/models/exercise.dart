import 'package:flutter/material.dart';

/// Modelo de ejercicio que soporta múltiples tipos de interacción
enum ExerciseType {
  multipleChoice, // Quiz estándar A/B/C/D
  dragAndDrop, // Arrastrar y soltar elementos al lugar correcto
  multiSelect, // Seleccionar varias respuestas correctas
  commandInput, // Escribir un comando o respuesta corta
  ordering, // Ordenar pasos en secuencia correcta
}

class Exercise {
  final int id;
  final int subcategoryId;
  final ExerciseType type;
  final String questionText;
  final String? hint; // Pista opcional
  // Para multipleChoice
  final String? optionA;
  final String? optionB;
  final String? optionC;
  final String? optionD;
  final String? correctOption; // 'A','B','C','D'
  // Para multiSelect
  final List<String>? options;
  final List<int>? correctIndices;
  // Para dragAndDrop / ordering
  final List<String>? items;
  final List<String>? targets; // Para drag&drop
  final List<int>? correctOrder; // Para ordering
  // Para commandInput
  final List<String>? acceptedAnswers; // Varias respuestas aceptadas
  // Común
  final String explanation;
  final String difficulty; // 'facil','medio','dificil'
  final int points;

  Exercise({
    required this.id,
    required this.subcategoryId,
    required this.type,
    required this.questionText,
    this.hint,
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
    required this.explanation,
    this.difficulty = 'medio',
    this.points = 15,
  });
}
