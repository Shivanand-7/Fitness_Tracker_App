import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutHistoryPage extends StatefulWidget {
  final DateTime date;
  const WorkoutHistoryPage({super.key, required this.date});

  @override
  _WorkoutHistoryPageState createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List<WorkoutTracker> trackedWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadTrackedWorkouts();
  }

  Future<void> _loadTrackedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final trackedWorkoutsData = prefs.getStringList('trackedWorkouts') ?? [];
    setState(() {
      trackedWorkouts = trackedWorkoutsData
          .map((data) => WorkoutTracker.fromJson(jsonDecode(data)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter workouts by the selected date
    List<WorkoutTracker> workoutsForDay = trackedWorkouts
        .where((workout) =>
            workout.date.year == widget.date.year &&
            workout.date.month == widget.date.month &&
            workout.date.day == widget.date.day)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Workouts on ${widget.date.day}/${widget.date.month}/${widget.date.year}'),
      ),
      body: workoutsForDay.isEmpty
          ? const Center(child: Text('No workouts for this day.'))
          : ListView.builder(
              itemCount: workoutsForDay.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(workoutsForDay[index].workoutName),
                  trailing: Icon(
                    workoutsForDay[index].isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: workoutsForDay[index].isCompleted
                        ? Colors.green
                        : Colors.grey,
                  ),
                );
              },
            ),
    );
  }
}
