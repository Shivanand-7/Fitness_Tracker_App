import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Steps extends StatefulWidget {
  const Steps({super.key});

  @override
  _StepsState createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  String _steps = "0";

  @override
  void initState() {
    super.initState();
    print('Initializing pedometer...');
    _initPedometer();
  }

  void _initPedometer() {
    Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );
    print('Pedometer initialized.');
  }

  void _onStepCount(StepCount event) {
    print('New step count: ${event.steps}');
    setState(() {
      _steps = event.steps.toString();
    });
    _saveSteps(event.steps);
  }

  void _onStepCountError(error) {
    print('Step Count Error: $error');
    setState(() {
      _steps = "Step Count not available";
    });
  }

  Future<void> _saveSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month}-${today.day}';
    await prefs.setInt(dateKey, steps);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            _steps,
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.w900),
          ),
          Text('Total Steps',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w500, height: 2)),
        ],
      ),
    );
  }
}
