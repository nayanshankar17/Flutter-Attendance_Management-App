import 'package:attendance_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  //The createState method is overridden to create an instance of the _LoginScreenState class, which manages the state of the LoginScreen widget.
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //TextEditingController is used to control the text being edited in the TextField widgets. It allows us to retrieve the current value of the text fields and perform actions based on that value.
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      //The AppBar widget is used to create a material design app bar at the top of the screen. It contains a title and centers it.
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      //The SingleChildScrollView widget allows the content of the screen to be scrollable when it exceeds the available space. This is useful for smaller screens or when the keyboard is open.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              SizedBox(height: 10),

              Text(
                "Sign in to continue",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 40),

              Center(
                child: Image.asset("assets/images/logo.jpg",height: 220,),
              ),

              SizedBox(height: 40),

              Text(
                "Username",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              TextField(
                controller: usernameController, //The controller property is set to the usernameController, which allows us to retrieve the value entered in this text field.

                decoration: InputDecoration(
                  hintText: "Enter username", //space Holder 

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),

              SizedBox(height: 25),

              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              TextField(
                controller: passwordController,
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "Enter password",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),

              SizedBox(height: 15),
              //The Row widget is used to create a horizontal layout for the "Remember Me" checkbox and the "Forgot Password?" text button. The mainAxisAlignment property is set to MainAxisAlignment.spaceBetween to space them apart.
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                      ),

                      Text("Remember Me"),
                    ],
                  ),

                  TextButton(
                    onPressed: () {},

                    child: Text("Forgot Password?"),
                  ),
                ],
              ),

              SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),  
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),

                  child: Text(
                    "Login",
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
    );
  }
}