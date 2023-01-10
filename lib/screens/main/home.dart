import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_me/screens/home/search.dart';

import 'package:social_me/services/auth.dart';

import '../home/feed.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService= AuthService();
  int _currentIndex =0;
  final List<Widget> _children = [Feed(),Search()];
  void onTabPressed(int index){
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
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
        backgroundColor: Colors.white,
        child: ListView(
          children:<Widget>[
            const DrawerHeader(decoration:
            BoxDecoration(color: Colors.green), child: Text("Settings")
            ),
            ListTile(
              title: const Text("Profile"),
              onTap: (){
                Navigator.pushNamed(context, '/profile',
                    arguments:FirebaseAuth.instance.currentUser?.uid);
              },
            ),
            ListTile(
              title: const Text("Edit"),
              onTap: (){
                Navigator.pushNamed(context, '/edit',
                    arguments:FirebaseAuth.instance.currentUser?.uid);
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
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabPressed,
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items:const [
        BottomNavigationBarItem(icon: Icon(Icons.home),
            label: 'Home',backgroundColor: Colors.black12),
        BottomNavigationBarItem(icon: Icon(Icons.search),
            label: 'Search',backgroundColor: Colors.black12),

      ],
      ),
      body: _children[_currentIndex],
    );
  }
}
