import 'package:flutter/material.dart';

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
              "Apprasial Letter",
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

          ScaffoldMessenger.of(context)
              .showSnackBar(

            SnackBar(
              content: Text(
                "$title Clicked",
              ),
            ),
          );
        },
      ),
    );
  }
}