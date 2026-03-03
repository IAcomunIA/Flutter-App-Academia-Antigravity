class Question {
  final int? id;
  final int subcategoryId;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String explanation;

  Question({this.id, required this.subcategoryId, required this.questionText, required this.optionA, required this.optionB, required this.optionC, required this.optionD, required this.correctOption, required this.explanation});

  factory Question.fromMap(Map<String, dynamic> map) => Question(
    id: map['id'],
    subcategoryId: map['subcategory_id'],
    questionText: map['question_text'],
    optionA: map['option_a'],
    optionB: map['option_b'],
    optionC: map['option_c'],
    optionD: map['option_d'],
    correctOption: map['correct_option'],
    explanation: map['explanation'],
  );
}