import 'package:flutter/material.dart';
import 'package:attendance_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                        onPressed: () {},

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
                        onPressed: () {},

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

        onTap: (index){
          setState(() {
            currentIndex= index;
          });
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
                    icon: Icon(Icons.person),
                    label: "Profile",
                  ),
                ],
              ),
    );
  }
}