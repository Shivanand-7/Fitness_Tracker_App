import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xff18b0e8),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture & Name
          Container(
            width: double.infinity, // Ensure the container takes full width
            color: Color(0xff18b0e8), // Set background color here
            padding: EdgeInsets.symmetric(
                vertical: 20), // Add padding inside the container
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff18b0e8),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundImage:
                          AssetImage('assets/profile.jpg'), // Change as needed
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Shivanand",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Account Settings Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Account Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),

          // List Items
          _buildListItem(Icons.person_outline, "Personal Information"),
          _buildListItem(
              Icons.account_balance_wallet_outlined, "Payments and Payouts"),
          _buildListItem(Icons.notifications_outlined, "Notifications"),
          _buildListItem(Icons.lock_outline, "Privacy and Sharing"),
        ],
      ),
    );
  }

  // Reusable List Tile Builder
  Widget _buildListItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
      onTap: () {},
    );
  }
}
