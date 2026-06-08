import 'package:flutter/material.dart';

class SalarySlipScreen extends StatelessWidget {
  const SalarySlipScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Salary Slip"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Employee Salary Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text("Employee ID : EMP001"),
                Text("Department : IT"),
                Text("Basic Salary : ₹45,000"),
                Text("Allowances : ₹5,000"),
                Text("Deductions : ₹2,000"),
                Divider(), // horizontal rule (hr)
                Text("Net Salary : ₹48,000",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}