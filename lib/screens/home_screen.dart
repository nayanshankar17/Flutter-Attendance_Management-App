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
  // add the controllers here later
  // ...
  // ...
  // ...

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

    DateTime now = DateTime.now();

    String currentDate = DateFormat('dd-MM-yyyy',).format(now); //punchIn date
    String currentTime = DateFormat('hh:mm a',).format(DateTime.now());; //punchIn time
    
    //entry is given in attendance DB's table
    await db.insert(
      'attendance', 
      {
        'email': widget.email,
        'date': currentDate,
        'status': 'Present',
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
    print(widget.email);
    print("Punch Out clicked");
    
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

    await db.update(
      'attendance',
      {
        'punchOut': currentTime,
        'workingHours': calculateHours(punchInTime, currentTime),
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
              Row(
                

                children: [
                  Image.asset("assets/images/logo.jpg", height:100),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        widget.name,

                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        widget.designation,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(widget.email),

                      Text(widget.phone),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),
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
              SizedBox(height: 300),

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