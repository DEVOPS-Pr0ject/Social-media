import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';
import 'package:social_me/services/auth.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService= AuthService();
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.green,
          actions: <Widget>[
            TextButton.icon(
              onPressed:() async {_authService.signOut();},
              icon: const Icon(Icons.person),
              label: const Text("SignOut"),
            )
          ]
    ),
    );
  }
}