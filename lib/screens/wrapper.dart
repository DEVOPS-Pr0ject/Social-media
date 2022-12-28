
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/screens/auth/Signup.dart';
import 'package:social_me/screens/main/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    print(user);
    if(user == null){
      //show auth system routes
      return const Signup();
    }
    //show main system routes
    return const Home();
  }
}