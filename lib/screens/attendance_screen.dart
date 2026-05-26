import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class AttendanceScreen extends StatefulWidget{
  @override 
  State<AttendanceScreen>
    createState() => _AttendanceScreenState(); 
}

class _AttendanceScreenState extends State<AttendanceScreen>{
  final DatabaseHelper dbHelper = DatabaseHelper();

  // function to format time properly
  String formatTime(String time){

    // if empty return --
    if(time.isEmpty){
      return "--";
    }

    // split hour and minute
    List<String> parts =
        time.split(":");

    // format hour
    String hour =
        parts[0].padLeft(2, '0');

    // format minute
    String minute =
        parts[1].padLeft(2, '0');

    // final formatted time
    return "$hour:$minute";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Records"),
      ),

      // FutureBuilder waits for: database query completion
      body: FutureBuilder(
        future: dbHelper.getAttendance(),
        builder: (context, snapshot) {
          
          // loading data
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //store fetched data
          List<Map<String, dynamic>>
            records = snapshot.data!;

          //no records
          if(records.isEmpty){
            return Center(
              child: Text("No attendance found"),
            );
          }

          return ListView.builder(
            itemCount: records.length, // number of entries
            itemBuilder: (context, index) {
              var record = records[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Date: ${record["date"]}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Punch In: ${record["punchIn"]}",
                      ),
                      Text(
                        "Punch Out: ${record["punchOut"]}",
                      ),
                      Text(
                        "Hours: ${record["workingHours"]}",
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}