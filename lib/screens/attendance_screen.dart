import 'package:flutter/material.dart';

import '../database/database_helper.dart';


class AttendanceScreen extends StatelessWidget {
  final String email;
  const AttendanceScreen({super.key, required this.email,});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Attendance"),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Calender"),
                Tab(text: "Summary",),
                Tab(text: "Punches")
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CalendarTab(),
              SummaryTab(),
              PunchesTab(email: email,),
            ],
          ),
        ),
    );
  }
}

class CalendarTab extends StatelessWidget{
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context){
    return const Center(
      child: Text(
        "Calender Comming Soon",
        style: TextStyle(fontSize: 18)
      ),
    );
  }
}

class SummaryTab extends StatelessWidget{
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context){
    return const Center(
      child: Text(
        "Calender Comming Soon",
        style: TextStyle(fontSize: 18)
      ),
    );
  }
}

class PunchesTab extends StatefulWidget {
  // store logged-in user email
  final String email;
  // constructor
  const PunchesTab({
    super.key,
    required this.email,
  });
  @override
  State<PunchesTab> createState() => _PunchesTabState();
}

class _PunchesTabState extends State<PunchesTab>{
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
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: dbHelper.getAttendance(
        widget.email,
      ),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Map<String, dynamic>>
            records = snapshot.data!;

        if (records.isEmpty) {
          return Center(
            child: Text(
              "No attendance found",
            ),
          );
        }

        return ListView.builder(

          itemCount: records.length,

          itemBuilder: (context, index) {

            var record = records[index];

            return Card(

              margin: EdgeInsets.all(10),

              child: ListTile(

                title: Text(
                  "Date: ${record["date"]}",
                ),

                subtitle: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Punch In: ${formatTime(record["punchIn"])}",
                    ),

                    Text(
                      "Punch Out: ${formatTime(record["punchOut"])}",
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
    );
  }
}