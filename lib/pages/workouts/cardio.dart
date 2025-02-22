import 'package:fitness_tracker/pages/home/widgets/current.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/fitness_program.dart';

class CardioWorkoutPage extends StatefulWidget {
  const CardioWorkoutPage({super.key});

  @override
  _CardioWorkoutPageState createState() => _CardioWorkoutPageState();
}

class _CardioWorkoutPageState extends State<CardioWorkoutPage> {
  ProgramType active = cardioWorkouts[0].type;

  void _changePrograms(ProgramType newType) {
    setState(() {
      active = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cardio Workouts'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cardio Workouts',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              scrollDirection: Axis.horizontal,
              itemCount: cardioWorkouts.length,
              itemBuilder: (context, index) {
                return Program(
                  program: cardioWorkouts[index],
                  active: cardioWorkouts[index].type == active,
                  onTap: _changePrograms,
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<FitnessProgram> cardioWorkouts = [
  FitnessProgram(
    name: 'Running',
    cals: '300 cals',
    time: '30 mins',
    type: ProgramType.cardio,
    image: AssetImage('assets/running.jpg'),
  ),
  FitnessProgram(
    name: 'Cycling',
    cals: '400 cals',
    time: '45 mins',
    type: ProgramType.cardio,
    image: AssetImage('assets/cycling.jpg'),
  ),
  FitnessProgram(
    name: 'Swimming',
    cals: '500 cals',
    time: '60 mins',
    type: ProgramType.cardio,
    image: AssetImage('assets/swimming.jpg'),
  ),
];
