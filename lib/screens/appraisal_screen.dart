import 'package:flutter/material.dart';

class AppraisalScreen extends StatelessWidget {
  const AppraisalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appraisal Letter",
        ),
      ),
      body: Padding(
        padding:const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Performance Appraisal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Congratulations!"),
                  SizedBox(height: 10),
                  Text("Your performance has been rated Excellent."),
                  SizedBox(height: 10),
                  Text("Salary Increment : 10%"),
                  Text("Effective Date : 01-04-2026"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}