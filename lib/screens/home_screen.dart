import 'package:flutter/material.dart';

//This is the structure/container.
class HomeScreen extends StatefulWidget {

  @override
  // State Class: stores variavles, changing UI, dynamic data , button clicks, databases
  // State<HomeScreen>: will return a State object connected to HomeScreen
  // createState(): returns the state class
  // _HomeScreenState(): Create and return an object of _HomeScreenState
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  // add the controllers here later



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
                  Text(
                    "Mr. XYZ \nSenior Associate",
                    style: TextStyle(
                      color: Colors.black,
                    ),
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