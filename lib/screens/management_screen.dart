import 'package:flutter/material.dart';
import 'appraisal_screen.dart';
import 'help_desk_screen.dart';
import 'salary_slip_screen.dart'; 

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key,});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Attendance Management",),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [
            buildManagementCard(
              context,
              Icons.badge_outlined,
              "Salary Slip",
            ),

            SizedBox(height: 15),
            
            buildManagementCard(
              context,
              Icons.support_agent,
              "Help Desk",
            ),

            SizedBox(height: 15),

            buildManagementCard(
              context,
              Icons.description_outlined,
              "Appraisal Letter",
            ), 
          ],
        ),
      ),
    );
  }
  Widget buildManagementCard(
    BuildContext context,
    IconData icon,
    String title,
  ){
    return Card(

      elevation: 3,

      shape: RoundedRectangleBorder(

        borderRadius:
            BorderRadius.circular(15),
      ),

      child: ListTile(

        leading: Container(

          padding: EdgeInsets.all(8),

          decoration: BoxDecoration(

            color: Colors.blue.shade50,

            borderRadius:
                BorderRadius.circular(10),
          ),

          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),

        title: Text(
          title,
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

        onTap: () {

          if(title == "Salary Slip"){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const SalarySlipScreen(),
              ),
            );
          }

          else if(title == "Help Desk"){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const HelpDeskScreen(),
              ),
            );
          }

          else if(title == "Appraisal Letter"){

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const AppraisalScreen(),
              ),
            );
          }
        }
      ),
    );
  }
}