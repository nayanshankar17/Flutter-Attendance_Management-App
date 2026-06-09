import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/database_helper.dart';
import 'package:intl/intl.dart';


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
              CalendarTab(email: email,),
              SummaryTab(email: email,),
              PunchesTab(email: email,),
            ],
          ),
        ),
    );
  }
}

//tab for calender
class CalendarTab extends StatefulWidget {

  final String email;

  const CalendarTab({
    super.key,
    required this.email,
  });

  @override
  State<CalendarTab> createState() =>  _CalendarTabState();
}

class SummaryTab extends StatefulWidget {

  final String email;

  const SummaryTab({
    super.key,
    required this.email,
  });

  @override
  State<SummaryTab> createState() =>
      _SummaryTabState();
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

//class for calandar tab
class _CalendarTabState extends State<CalendarTab>{
  
  final DatabaseHelper dbHelper = DatabaseHelper();

  List<Map<String,dynamic>>
  attendanceRecords = [];

  Map<String, dynamic>? selectedRecord;
  bool isLoading = false;
  Future<void> loadAttendance(DateTime selectedDay) async {

    setState(() {
      isLoading = true;
    });

    String date = DateFormat('dd-MM-yyyy')  .format(selectedDay);

    final record = await dbHelper.getAttendanceByDate(widget.email,date);

    setState(() {
      selectedRecord = record;
      isLoading = false;
    });
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  Future<void>loadAttendanceStatuses() async {
    attendanceRecords = await dbHelper.getAttendanceStatuses(widget.email);
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadAttendanceStatuses();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2035, 12, 31),
          focusedDay: _focusedDay,

          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },

          onDaySelected: (
            selectedDay,
            focusedDay,
          ) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            loadAttendance(selectedDay);
          },


          calendarBuilders: CalendarBuilders(
            
            defaultBuilder: (context,day,focusedDay,) {

              if (day.weekday ==DateTime.saturday || day.weekday == DateTime.sunday) {
                return Container(
                  margin:const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),

                    borderRadius:
                        BorderRadius.circular(8),
                    ),

                  child: Center(
                    child: Text(
                      '${day.day}',
                    ),
                  ),
                );
              }
              String date = DateFormat('dd-MM-yyyy').format(day);

              Map<String,dynamic>? record;

              try {

                record =
                    attendanceRecords.firstWhere(
                  (r) => r['date'] == date,
                );

              } catch (e) {
                record = null;
              }

              Color? color;

              if (record != null) {

                switch (
                  record['status']
                ) {

                  case 'Present':
                    color = Colors.green;
                    break;

                  case 'Late':
                    color = Colors.blue;
                    break;

                  case 'Half Day':
                    color = Colors.amber;
                    break;

                  case 'Absent':
                    color = Colors.red;
                    break;
                  case 'Incomplete':
                    color = Colors.purple;
                    break;
                }
              }

              return Container(
                margin:
                    const EdgeInsets.all(4),

                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(8),
                ),

                child: Center(
                  child: Text(
                    '${day.day}',
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  _selectedDay == null
                      ? "No date selected"
                      : "Date: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}",
                ),

                const SizedBox(height: 10),

                if (isLoading)
                  const CircularProgressIndicator(),

                if (!isLoading &&
                    selectedRecord == null)
                  const Text(
                    "No attendance record",
                  ),
                
                if (!isLoading && selectedRecord != null)

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Punch In: ${selectedRecord!["punchIn"]}",
                      ),

                      Text(
                        "Punch Out: ${selectedRecord!["punchOut"]}",
                      ),

                      Text(
                        "Hours: ${selectedRecord!["workingHours"]}",
                      ),
                      Text(
                        "Status: ${selectedRecord!["status"]}",
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
}
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

                onTap: () {
                  print(record);
                },

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

class _SummaryTabState
    extends State<SummaryTab> {

  final DatabaseHelper dbHelper =
      DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(

      future: dbHelper.getAttendance(
        widget.email,
      ),

      builder: (context, snapshot) {

        if (!snapshot.hasData) {

          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        List<Map<String, dynamic>>
            records = snapshot.data!;

        int presentCount = 0;
        int absentCount = 0;
        int leaveCount = 0;

        for (var record in records) {

          String status =
              record['status'];

          if (status == "Present") {
            presentCount++;
          }

          else if (status == "Absent") {
            absentCount++;
          }

          else if (status == "Leave") {
            leaveCount++;
          }
        }

        return Padding(

          padding:
              const EdgeInsets.all(16),

          child: Column(

            children: [

              buildSummaryCard(
                "Present",
                presentCount,
                Colors.green,
              ),

              const SizedBox(height: 15),

              buildSummaryCard(
                "Absent",
                absentCount,
                Colors.red,
              ),

              const SizedBox(height: 15),

              buildSummaryCard(
                "Leave",
                leaveCount,
                Colors.orange,
              ),
            ],
          ),
        );
      },
    );
  }


  Widget buildSummaryCard(
    String title,
    int count,
    Color color,
  ) {

    return Card(

      elevation: 3,

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: color,
        ),

        title: Text(title),

        trailing: Text(

          count.toString(),

          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}