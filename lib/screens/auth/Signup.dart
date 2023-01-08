

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_me/services/auth.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final AuthService _authService = AuthService();
  String email = 'email';
  String password = 'password';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
     appBar:AppBar(
      backgroundColor: Colors.green,
      elevation: 8,
      title: Text("Signup"),
     ),
     body: Container(
      padding: EdgeInsets.symmetric(vertical: 50,horizontal: 20),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  icon: Icon(Icons.email_outlined,color: Colors.white),
                label: Text('Enter Your Email'),
                  labelStyle: TextStyle(
                      color: Colors.white
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(30)
                  )
              ),
              onChanged: (val) => setState(() {
              email = val;
            }),
          ),
            SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                icon: Icon(Icons.password_outlined,color: Colors.white),
                  label: Text('Enter Your Password (6 Digits only)'),
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(30)
                )
              ),
              onChanged: (val) => setState(() {
                password = val;
              }),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green
                ),
              onPressed: () async => {
                _authService.signUp(email, password),
              }, 
              child: Text("SignUp")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green
              ),
              onPressed: () async => {
                _authService.signIn(email, password),
              }, 
              child: Text("SignIn")),
              
          ],
          )
        ),
     ),
    );
  }
}