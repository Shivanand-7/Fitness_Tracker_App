import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  String steps = "0";
  String calories = "0";
  String distance = "0";
  String hours = "0";

  @override
  void initState() {
    super.initState();
    _loadStepData();
  }

  Future<void> _loadStepData() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    int stepCount = prefs.getInt(dateKey) ?? 0;

    setState(() {
      steps = stepCount.toString();
      calories = (stepCount * 0.04)
          .toStringAsFixed(1); // Approximation: 0.04 kcal per step
      distance = (stepCount * 0.0008)
          .toStringAsFixed(1); // Approximation: 0.0008 km per step
      hours = (stepCount * 0.0001)
          .toStringAsFixed(1); // Approximation: 0.0001 hr per step
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Stats(value: calories, unit: 'kcal', label: 'Calories'),
        Stats(value: distance, unit: 'km', label: 'Distance'),
        Stats(value: hours, unit: 'hr', label: 'Hours'),
      ],
    );
  }
}

class Stats extends StatelessWidget {
  final String value;
  final String unit;
  final String label;

  const Stats({
    super.key,
    required this.value,
    required this.unit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
              text: value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
