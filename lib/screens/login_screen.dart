import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                Navigator.push( //a new screen is pushed onto the stack when the button is pressed
                  context,
                  MaterialPageRoute( //Navigates to HomeScreen when the button is pressed
                    builder: (context) => HomeScreen(),
                  ),
                );

              },

              child: Text("Login"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute( //Navigates to SignupScreen when the button is pressed
                    builder: (context) => SignupScreen(),
                  ),
                );

              },

              child: Text("Create Account"),
            )

          ],
        ),
      ),
    );
  }
}