import 'package:fitness_tracker/helpers.dart';
import 'package:fitness_tracker/pages/details/widgets/dates.dart';
import 'package:fitness_tracker/screens/workout_history_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeightTrainingPage extends StatefulWidget {
  const WeightTrainingPage({super.key});

  @override
  _WeightTrainingPageState createState() => _WeightTrainingPageState();
}

class _WeightTrainingPageState extends State<WeightTrainingPage> {
  DateTime selectedDate = DateTime.now(); // Default to current date
  List<WorkoutTracker> workouts = [];
  TextEditingController workoutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final trackedWorkoutsData = prefs.getStringList('trackedWorkouts') ?? [];
    setState(() {
      workouts = trackedWorkoutsData
          .map((data) => WorkoutTracker.fromJson(jsonDecode(data)))
          .toList();
    });
  }

  Future<void> _saveWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutData = workouts.map((w) => jsonEncode(w.toJson())).toList();
    await prefs.setStringList('trackedWorkouts', workoutData);
  }

  void _addWorkout() {
    if (workoutController.text.isNotEmpty) {
      setState(() {
        workouts.add(WorkoutTracker(
          workoutName: workoutController.text,
          date: selectedDate,
          isCompleted: false,
        ));
        _saveWorkouts();
        workoutController.clear();
      });
    }
  }

  void _viewWorkoutHistory(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutHistoryPage(date: date),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weight Training')),
      body: Column(
        children: <Widget>[
          Dates(),
          TextField(
            controller: workoutController,
            decoration: InputDecoration(
              labelText: 'Enter workout',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: _addWorkout,
            child: Text('Add Workout'),
          ),
          ElevatedButton(
            onPressed: () => _viewWorkoutHistory(selectedDate),
            child: Text('View Workouts for this Date'),
          ),
        ],
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final bool active;
  final DateTime date;
  const DateBox({
    super.key,
    this.active = false,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
          gradient: active
              ? LinearGradient(
                  colors: [Color(0xff92e2ff), Color(0xff1ebdf8)],
                  begin: Alignment.topCenter)
              : null,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xffe1e1e1))),
      child: DefaultTextStyle.merge(
        style: active ? TextStyle(color: Colors.white) : null,
        child: Column(
          children: [
            Text(
              daysOfWeek[date.weekday]!,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              date.day.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
