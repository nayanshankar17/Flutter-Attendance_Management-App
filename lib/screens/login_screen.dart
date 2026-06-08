  import 'package:attendance_app/screens/home_screen.dart';
  import 'package:flutter/material.dart';

  // used for JSON encoding & decoding
  import 'dart:convert';

  // Used to access app assets and system services like rootBundle
  import 'package:flutter/services.dart';

  //Shared preference package
  import 'package:shared_preferences/shared_preferences.dart';

  class LoginScreen extends StatefulWidget {

    
    @override
    //The createState method is overridden to create an instance of the _LoginScreenState class, which manages the state of the LoginScreen widget.
    State<LoginScreen> createState() => _LoginScreenState();
  }

  class _LoginScreenState extends State<LoginScreen> {

    //TextEditingController is used to control the text being edited in the TextField widgets. It allows us to retrieve the current value of the text fields and perform actions based on that value.
    final TextEditingController emailController =
        TextEditingController();

    final TextEditingController passwordController =
        TextEditingController();

    @override
    void initState() {
      super.initState();

      WidgetsBinding.instance
          .addPostFrameCallback((_) {

        checkLogin();
      });
    }


    bool rememberMe = false; // used to maintain the status of remember_me button

    //fucntion of remember_me button
    Future<void> checkLogin() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool? isLoggedIn = prefs.getBool("isLoggedIn");

      String? savedEmail = prefs.getString("email");

      if (isLoggedIn == true && savedEmail != null) {
        String jsonString = await rootBundle.loadString('assets/data/users.json');

        List users = json.decode(jsonString);

        for (var user in users) {

          if (user["email"] == savedEmail) {

            Navigator.pushReplacement(
              context,

              MaterialPageRoute(
                builder: (context) => HomeScreen(

                  name: user["name"],
                  email: user["email"],
                  phone: user["phone"],
                  designation: user["designation"],
                ),
              ),
            );

            break;
          }
        }
      }
    }

    //function for checking the login credentials 
    Future<void> loginUser() async{
      //Load JSON file
      String jsonString = await rootBundle.loadString('assets/data/users.json');

      //Decode JSON
      List users = json.decode(jsonString);

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      bool isUserFound = false; // used to check is login details are correct

      
      //cpmapres the entered details with all the predefined credentials
      for (var user in users){
        if(user["email"] == email && user["password"] == password){

          isUserFound = true; // successful

          SharedPreferences prefs = await SharedPreferences.getInstance();

          //save details for remember_me button
          if(rememberMe){
            await prefs.setBool("isLoggedIn", true);
            await prefs.setString("email", email);
          }
          //if details are correct => login successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                name: user["name"],
                email: user["email"],
                phone: user["phone"],
                designation: user["designation"],
              ),
            ),  
          ); 
          break;
        }
        
      }
      //if wrong details entered
      if(!isUserFound){
        ScaffoldMessenger.of(context).showSnackBar(// snackbar: a small barappears at the bottom of the app
          SnackBar(
            content: Text("Invalid email or password"), 
          ),
        );
      }
    }

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
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                TextField(
                  controller: emailController, //The controller property is set to the usernameController, which allows us to retrieve the value entered in this text field.

                  decoration: InputDecoration(
                    hintText: "Enter email", //space Holder 

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
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),

                        Text("Remember Me"),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    onPressed: loginUser,

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