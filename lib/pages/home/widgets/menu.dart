import 'package:fitness_tracker/pages/workouts/weight.dart';
import 'package:fitness_tracker/screens/settings.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Container(
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height, // Take up full screen height
        padding: EdgeInsets.zero, // Remove the padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section with Fitness Tracker text and background color
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *
                  0.3, // Set the height to cover more space
              color: Color(0xff18b0e8), // Set the background color here
              padding: EdgeInsets.all(16), // Padding inside the colored section
              child: Center(
                child: Text(
                  "Fitness Tracker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Menu Items
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/');
                      },
                      child: _buildMenuItem(context, Icons.home, "Home")),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/details');
                      },
                      child: _buildMenuItem(
                          context, Icons.directions_walk, "Steps")),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeightTrainingPage()),
                      );
                    },
                    child: _buildMenuItem(
                        context, Icons.fitness_center, "Workout Programs"),
                  ),
                  GestureDetector(
                      onTap: () {
                        // Navigator.of(context).pushNamed('/details');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountSettingsScreen()),
                        );
                      },
                      child:
                          _buildMenuItem(context, Icons.settings, "Settings")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      // onTap: () {
      //   Navigator.pop(context); // Close the menu when tapped
      // },
    );
  }
}
