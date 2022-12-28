

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
     appBar:AppBar(
      backgroundColor: Colors.green,
      elevation: 8,
      title: Text("Signup"),
     ),
     body: Container(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              onChanged: (val) => setState(() {
              email = val;
            }),
          ),
            TextFormField(
              onChanged: (val) => setState(() {
                password = val;
              }),
            ),
            ElevatedButton(

              onPressed: () async => {
                _authService.signUp(email, password),
              }, 
              child: Text("SignUp")),
            ElevatedButton(
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