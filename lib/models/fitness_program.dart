import 'package:flutter/material.dart';

enum ProgramType {
  cardio,
  weights,
}

class FitnessProgram {
  final AssetImage image;
  final String name;
  final String cals;
  final String time;
  final ProgramType type;

  FitnessProgram({
    required this.image,
    required this.name,
    required this.cals,
    required this.time,
    required this.type,
  });
}

final List<FitnessProgram> fitnessPrograms = [
  FitnessProgram(
    image: AssetImage('assets/run.jpg'),
    name: 'Cardio',
    cals: '220kkal',
    time: '20min',
    type: ProgramType.cardio,
  ),
  FitnessProgram(
      image: AssetImage('assets/gym1.jpg'),
      name: 'Weight Trainig',
      cals: '220kkal',
      time: '20min',
      type: ProgramType.weights),
];
