class WorkoutTracker {
  String workoutName;
  DateTime date;
  bool isCompleted;

  WorkoutTracker({
    required this.workoutName,
    required this.date,
    required this.isCompleted,
  });

  factory WorkoutTracker.fromJson(Map<String, dynamic> json) {
    return WorkoutTracker(
      workoutName: json['workoutName'],
      date: DateTime.parse(
          json['date']), // Convert stored string back to DateTime
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutName': workoutName,
      'date':
          date.toIso8601String(), // Store date as string for SharedPreferences
      'isCompleted': isCompleted,
    };
  }
}
