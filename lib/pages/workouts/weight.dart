import 'package:fitness_tracker/pages/details/widgets/dates.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/models/workout_exercise.dart';
import 'package:fitness_tracker/models/workout_tracker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightTrainingPage extends StatefulWidget {
  const WeightTrainingPage({super.key});

  @override
  _WeightTrainingPageState createState() => _WeightTrainingPageState();
}

class _WeightTrainingPageState extends State<WeightTrainingPage> {
  List<WorkoutTracker> trackedWorkouts = [];
  List<WorkoutExercise> selectedExercises = [];
  String selectedDay = '';
  DateTime selectedDate = DateTime.now();
  bool workoutsAdded = false;

  List<WorkoutExercise> workoutExercises = [
    WorkoutExercise(name: 'Push-ups', muscleGroup: 'Chest'),
    WorkoutExercise(name: 'Bench Press', muscleGroup: 'Chest'),
    WorkoutExercise(name: 'Incline DB Press', muscleGroup: 'Chest'),
    WorkoutExercise(name: 'Decline Bench Press', muscleGroup: 'Chest'),
    WorkoutExercise(name: 'Pec Dec Flys', muscleGroup: 'Chest'),
    WorkoutExercise(name: 'Skull Crusher', muscleGroup: 'Triceps'),
    WorkoutExercise(name: 'Triceps Pushdown', muscleGroup: 'Triceps'),
    WorkoutExercise(name: 'Overhead Triceps Extension', muscleGroup: 'Triceps'),
    WorkoutExercise(name: 'Seated Dips', muscleGroup: 'Triceps'),
    WorkoutExercise(name: 'Bent-over Row', muscleGroup: 'Back'),
    WorkoutExercise(name: 'Lat Pulldown', muscleGroup: 'Back'),
    WorkoutExercise(name: 'Seated Row', muscleGroup: 'Back'),
    WorkoutExercise(name: 'Single Arm DB Row', muscleGroup: 'Back'),
    WorkoutExercise(name: 'Z Bar Curl', muscleGroup: 'Biceps'),
    WorkoutExercise(name: 'Single Arm DB Curl', muscleGroup: 'Biceps'),
    WorkoutExercise(name: 'Preacher Curl', muscleGroup: 'Biceps'),
    WorkoutExercise(name: 'Hammer Curl', muscleGroup: 'Biceps'),
    WorkoutExercise(name: 'Crunches', muscleGroup: 'Abs'),
    WorkoutExercise(name: 'Leg Raise', muscleGroup: 'Abs'),
    WorkoutExercise(name: 'Plank', muscleGroup: 'Abs'),
    WorkoutExercise(name: 'Military Press', muscleGroup: 'Shoulders'),
    WorkoutExercise(name: 'Cable Front Raise', muscleGroup: 'Shoulders'),
    WorkoutExercise(name: 'Lateral Raise', muscleGroup: 'Shoulders'),
    WorkoutExercise(name: 'Reverse Pec Flys', muscleGroup: 'Shoulders'),
    WorkoutExercise(name: 'Shrugs', muscleGroup: 'Shoulders'),
    WorkoutExercise(name: 'Squat', muscleGroup: 'Legs'),
    WorkoutExercise(name: 'Leg Press', muscleGroup: 'Legs'),
    WorkoutExercise(name: 'Leg Extension', muscleGroup: 'Legs'),
    WorkoutExercise(name: 'Leg Curl', muscleGroup: 'Legs'),
    WorkoutExercise(name: 'Calf Raise', muscleGroup: 'Legs'),
  ];

  @override
  void initState() {
    super.initState();
    _loadTrackedWorkouts();
    _selectDate(DateTime.now());
  }

  void _toggleCompletion(int index) {
    setState(() {
      final exerciseName = selectedExercises[index].name;
      final existingWorkoutIndex = trackedWorkouts.indexWhere((workout) =>
          workout.workoutName == exerciseName &&
          workout.date.year == selectedDate.year &&
          workout.date.month == selectedDate.month &&
          workout.date.day == selectedDate.day);

      if (existingWorkoutIndex != -1) {
        trackedWorkouts[existingWorkoutIndex].isCompleted =
            !trackedWorkouts[existingWorkoutIndex].isCompleted;
      } else {
        trackedWorkouts.add(WorkoutTracker(
          workoutName: exerciseName,
          date: selectedDate,
          isCompleted: true,
        ));
      }
    });
    _saveTrackedWorkouts();
  }

  void _selectDay(String day) {
    setState(() {
      selectedDay = day;
      if (day == 'Triceps & Abs') {
        selectedExercises = workoutExercises
            .where((exercise) =>
                exercise.muscleGroup == 'Triceps' ||
                exercise.muscleGroup == 'Abs')
            .toList();
      } else if (day == 'Biceps & Abs') {
        selectedExercises = workoutExercises
            .where((exercise) =>
                exercise.muscleGroup == 'Biceps' ||
                exercise.muscleGroup == 'Abs')
            .toList();
      } else {
        selectedExercises = workoutExercises
            .where((exercise) => exercise.muscleGroup == day)
            .toList();
      }
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _addWorkoutsToDate() {
    setState(() {
      for (var exercise in selectedExercises) {
        if (!trackedWorkouts.any((workout) =>
            workout.workoutName == exercise.name &&
            workout.date.day == selectedDate.day &&
            workout.date.month == selectedDate.month &&
            workout.date.year == selectedDate.year)) {
          trackedWorkouts.add(WorkoutTracker(
            workoutName: exercise.name,
            date: selectedDate,
            isCompleted: false,
          ));
        }
      }
      workoutsAdded = true;
    });
    _saveTrackedWorkouts();
  }

  Future<void> _loadTrackedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final trackedWorkoutsData = prefs.getStringList('trackedWorkouts') ?? [];
    setState(() {
      trackedWorkouts = trackedWorkoutsData.map((data) {
        final parts = data.split('|');
        return WorkoutTracker(
          workoutName: parts[0],
          date: DateTime.parse(parts[1]),
          isCompleted: parts[2] == 'true',
        );
      }).toList();
    });
  }

  Future<void> _saveTrackedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final trackedWorkoutsData = trackedWorkouts.map((workout) {
      return '${workout.workoutName}|${workout.date.toIso8601String()}|${workout.isCompleted}';
    }).toList();
    await prefs.setStringList('trackedWorkouts', trackedWorkoutsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Training Workouts',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), // Adjust opacity as needed
              BlendMode.lighten,
            ),
            image: AssetImage('assets/gym1.jpg'), // Use your asset image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Dates(),
              SizedBox(height: 20),
              Text('Select Workout Day',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedDay.isEmpty ? null : selectedDay,
                decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: Colors.blueGrey[700], fontSize: 16),
                  filled: true,
                  fillColor: Color(0xFFE0F7FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF1EBDF8), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF92E2FF), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Color(0xFF1EBDF8), width: 2.5),
                  ),
                ),
                icon: Icon(Icons.fitness_center, color: Color(0xFF1EBDF8)),
                dropdownColor: Colors.white,
                onChanged: (String? newValue) => _selectDay(newValue!),
                items: [
                  'Chest',
                  'Triceps & Abs',
                  'Back',
                  'Biceps & Abs',
                  'Shoulders',
                  'Legs'
                ]
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[800],
                              letterSpacing: 0.8,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWorkoutsToDate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF92E2FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Add Workouts to Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),
              if (workoutsAdded)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Workouts added successfully!',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 16.0),
                  itemCount: selectedExercises.length,
                  itemBuilder: (context, index) {
                    // Find the workout for the selected date and workout name
                    bool isCompleted = trackedWorkouts.any((workout) {
                      return workout.workoutName ==
                              selectedExercises[index].name &&
                          workout.date.year == selectedDate.year &&
                          workout.date.month == selectedDate.month &&
                          workout.date.day == selectedDate.day &&
                          workout.isCompleted;
                    });

                    return CheckboxListTile(
                      title: Text(selectedExercises[index].name),
                      value: isCompleted,
                      onChanged: (bool? value) {
                        if (value != null) {
                          _toggleCompletion(index); // Toggle completion status
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
