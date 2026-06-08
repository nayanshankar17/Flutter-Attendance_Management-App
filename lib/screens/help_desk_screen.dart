import 'package:flutter/material.dart';

class HelpDeskScreen extends StatelessWidget {
  const HelpDeskScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Help Desk"),
      ),

      body: ListView(
        
        padding:const EdgeInsets.all(16),

        children: [
          buildContactCard(
            "HR Department",
            "+91 9876543210",
            Icons.people,
          ),
          buildContactCard(
            "Reporting Manager",
            "+91 9123456789",
            Icons.person,
          ),
          buildContactCard(
            "IT Support",
            "+91 9988776655",
            Icons.computer,
          ),
        ],
        
      ),
    );
  }

  Widget buildContactCard(String title, String phone, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(phone),
      ),
    );
  }

}