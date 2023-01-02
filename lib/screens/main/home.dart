import 'package:flutter/material.dart';

import 'package:social_me/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService= AuthService();
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.green,

    ),
      floatingActionButton:FloatingActionButton(
          onPressed:() {
            Navigator.pushNamed(context,'/add');
            },
        child:const Icon(Icons.add)),
        drawer: Drawer(
          child: ListView(
            children:<Widget>[
              const DrawerHeader(decoration:
              BoxDecoration(color: Colors.cyan), child: Text("Drawer Header")
              ),
              ListTile(
                title: const Text("Profile"),
                onTap: (){
                  Navigator.pushNamed(context, '/profile');
                },
              ),


              ListTile(
                title: const Text("LogOut"),
                onTap: () async {
                  authService.signOut();
                },
              )
            ],
          ),
        )
    );
  }
}