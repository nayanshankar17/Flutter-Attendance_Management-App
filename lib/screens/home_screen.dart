import 'package:attendance_app/screens/attendance_screen.dart';
import 'package:attendance_app/screens/login_screen.dart';
import 'package:attendance_app/screens/management_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

// date time formatting library
import 'package:intl/intl.dart'; 

//imports DatabaseHelper class 
import '../database/database_helper.dart';

//This is the structure/container.
class HomeScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String designation;

  const HomeScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.designation,
  });


  @override
  // State Class: stores variables, changing UI, dynamic data , button clicks, databases
  // State<HomeScreen>: will return a State object connected to HomeScreen
  // createState(): returns the state class
  // _HomeScreenState(): Create and return an object of _HomeScreenState
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> logoutUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen()
      ),   
    );
  }
  
  // stores the idx of tabs from bottom navihation bar
  int currentIndex = 0;


  //func to handle punchIn
  Future<void> punchIn() async{
    DateTime now = DateTime.now();

    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Weekend Holiday",
          ),
        ),
      );
      return;
    }

    final db = await dbHelper.database;

    // check today's attendance
    var todayRecord = await getTodayAttendance();

    //if already punchedIn
    if(todayRecord != null){
      ScaffoldMessenger.of(context).
        showSnackBar(
          SnackBar(
            content: Text("Already punchedIn"),
          )
        );
      return;
    }

    String currentDate = DateFormat('dd-MM-yyyy',).format(now); //punchIn date
    String currentTime = DateFormat('hh:mm a',).format(DateTime.now());; //punchIn time
    
    //entry is given in attendance DB's table
    await db.insert(
      'attendance', 
      {
        'email': widget.email,
        'date': currentDate,
        'status': 'Pending',
        'punchIn': currentTime,
        'punchOut': '',
        'workingHours': '',
      }  
    );

    //snackbar shows alert
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Punch In recorded."),
      ),
    );
  }
  
  //func to punchOut
  Future<void> punchOut() async{
    DateTime now = DateTime.now();

    if (now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Weekend Holiday",
          ),
        ),
      );

      return;
    }

    
    final db = await dbHelper.database;

    var todayRecord = await getTodayAttendance();

    // no punch in yet
    if (todayRecord == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Please Punch In First",
          ),
        ),
      );
      return;
    }
    // already punched out
    if (todayRecord['punchOut'] != '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            "Already Punched Out",
          ),
        ),
      );

      return;
    }

    String currentTime = DateFormat('hh:mm a',).format(DateTime.now());; //punchIn time

    int latestId = todayRecord['id']; 
    String punchInTime = todayRecord['punchIn']; //punchIn time

    String status = calculateStatus(punchInTime,currentTime);

    await db.update(
      'attendance',
      {
        'punchOut': currentTime,

        'workingHours':
            calculateHours(
              punchInTime,
              currentTime,
            ),

        'status': status,
      },
      where: 'id = ?',
      whereArgs: [latestId],
    );
    
    

    //snackbar shows alert
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Punch Out recorded."),
      ),
    );
  }

  String calculateHours(
    String punchIn,
    String punchOut,
  ) {

    DateFormat format =
        DateFormat('hh:mm a');

    DateTime inTime =
        format.parse(punchIn);

    DateTime outTime =
        format.parse(punchOut);

    Duration difference =
        outTime.difference(inTime);

    int hours =
        difference.inHours;

    int minutes =
        difference.inMinutes % 60;

    return "$hours hrs $minutes mins";
  }

  // func to fetch today's attendance record
  String calculateStatus(String punchIn,String punchOut,) {

    if(punchIn.isEmpty){
      return "Absent";
    }

    if(punchOut.isEmpty){
      return "Incomplete";
    }
    DateFormat format =
        DateFormat('hh:mm a');

    DateTime inTime =
        format.parse(punchIn);

    DateTime outTime =
        format.parse(punchOut);

    Duration duration =
        outTime.difference(inTime);

    double hours =
        duration.inMinutes / 60;

    DateTime lateLimit =
        format.parse('09:05 AM');

    DateTime halfDayLimit =
        format.parse('04:55 PM');

    if (hours < 6) {
      return "Absent";
    }

    if (hours < 8) {
      return "Half Day";
    }

    if (outTime.isBefore(halfDayLimit)) {
      return "Half Day";
    }

    if (inTime.isAfter(lateLimit)) {
      return "Late";
    }

    return "Present";
  }

  // Function to check if today's attendance already exists
  Future<Map<String, dynamic>?>
    getTodayAttendance() async {
      final db = await dbHelper.database;
      DateTime now = DateTime.now();
      String currentDate = DateFormat('dd-MM-yyyy',).format(now);

      // query attendance table, fetch records matching today's date and user email
      List<Map<String, dynamic>> records = await db.query(
        'attendance',
        where: 'date = ? AND email = ?', // ? acts like placeholder
        whereArgs: [
          currentDate,
          widget.email,
        ], // value to replace ?
        limit: 1,
      );
      // if attendance exists
      if(records.isNotEmpty){
        return records.first;
      }
      // no attendance found
      return null;
    }


    //============================================================
    //                      MOCK DATA
    //============================================================
    Future<void> generateMockData() async {

      final db = await dbHelper.database;

      DateTime today = DateTime.now();

      for (int i = 1; i <= 60; i++) {

        DateTime day =
            today.subtract(Duration(days: i));

        // Skip weekends
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          continue;
        }

        String date =
            DateFormat('dd-MM-yyyy')
                .format(day);

        String status;

        if (i % 10 == 0) {
          status = "Absent";
        }
        else if (i % 7 == 0) {
          status = "Late";
        }
        else if (i % 5 == 0) {
          status = "Half Day";
        }
        else {
          status = "Present";
        }

        String punchIn;
        String punchOut;
        String workingHours;

        switch(status){

          case "Late":
            punchIn = "09:20 AM";
            punchOut = "06:00 PM";
            workingHours = "8 hrs 40 mins";
            break;

          case "Half Day":
            punchIn = "09:00 AM";
            punchOut = "03:30 PM";
            workingHours = "6 hrs 30 mins";
            break;

          case "Absent":
            punchIn = "";
            punchOut = "";
            workingHours = "";
            break;

          default:
            punchIn = "08:55 AM";
            punchOut = "06:05 PM";
            workingHours = "9 hrs 10 mins";
        }

        await db.insert(
          'attendance',
          {
            'email': widget.email,
            'date': date,
            'status': status,
            'punchIn': punchIn,
            'punchOut': punchOut,
            'workingHours': workingHours,
          },
        );
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Mock Data Generated",
          ),
        ),
      );
    }

    
    Widget buildStatusCard() {
      return FutureBuilder(
        future: getTodayAttendance(),
        builder: (context, snapshot) {
          String status = "Not Marked";
          String punchIn = "--";
          String punchOut = "--";
          if(snapshot.hasData && snapshot.data != null){
            var record = snapshot.data!;
            status = record["status"];
            punchIn = record["punchIn"].isEmpty ? "--" : record["punchIn"];
            punchOut = record["punchOut"].isEmpty ? "--" : record["punchOut"];
          }
          return SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 4,
              shape:
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              child: Padding(
                padding: const EdgeInsets.all(16), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Attendance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Status : $status"),
                    Text("Punch In : $punchIn"),
                    Text("Punch Out : $punchOut"),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Card(

                elevation: 4,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(16),

                  child: Row(

                    children: [

                      CircleAvatar(

                        radius: 35,

                        backgroundImage:
                            AssetImage(
                          "assets/images/logo.jpg",
                        ),
                      ),

                      SizedBox(width: 20),

                      Expanded(

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(

                              widget.name,

                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(
                              widget.designation,
                            ),

                            SizedBox(height: 5),

                            Text(
                              widget.email,
                            ),

                            Text(
                              widget.phone,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              buildStatusCard(),

              SizedBox(height: 20),
              Row(
                children: [
                  //used when two items are added in a row using width
                  Expanded(
                    child: SizedBox(
                      height: 60,

                      child: ElevatedButton(
                        onPressed: punchIn,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: Text(
                          "Punch In",

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //second SeizedBox
                  SizedBox(width: 20),

                  Expanded(
                    child: SizedBox(
                      height: 60,

                      child: ElevatedButton(
                        onPressed: punchOut,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        child: Text(
                          "Punch Out",

                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: logoutUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: generateMockData,
                  child: const Text(
                    "Generate Mock Data",
                  ),
                )
            ],
            
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,
        //bottom navigation_bar controls
        onTap: (index) {
          // Home Tab
          if(index == 0){
            setState(() {
              currentIndex = 0;
            });
          }

          // Attendance Tab
          else if(index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                  AttendanceScreen(email: widget.email,),
              ),
            );
          }
          // Management Tab
          else if(index == 2){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagementScreen(),
              ),
            );
          }
        },
        
        items: const[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Management",
          ),
        ],
      ),
    );
  }
}