import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/screens/main/posts/list.dart';
import 'package:social_me/services/posts.dart';
import 'package:social_me/services/user.dart';
import 'dart:core';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
   final PostService _postService = PostService();
   final UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    final String uid =ModalRoute.of(context)?.settings.arguments as String;
    return MultiProvider(
      providers: [
        StreamProvider.value(value:
        _userService.isFollowing(FirebaseAuth.instance.currentUser?.uid, uid),
            initialData: null),
        StreamProvider.value(value:
        _postService.getPostsByUser(uid), initialData: null),
        StreamProvider.value(value:
        _userService.getUserInfo(uid),
          initialData: null)
      ],
        child: Scaffold(
           body: DefaultTabController(length: 2,
              child: NestedScrollView(headerSliverBuilder: (context, _){
                 return [
                   SliverAppBar(
                    floating: false,
                    pinned: true,
                    expandedHeight: 150,
                    flexibleSpace:  FlexibleSpaceBar(
                      background: Image.network(Provider
                          .of<UserModel?>(context)?.bannerImageUrl ?? "https://i.pinimg.com/originals/41/8e/1a/418e1a67a6ff452f43a39a4d913dc540.jpg",
                        fit: BoxFit.cover,

                      )),
                   ),
                   SliverList(delegate: SliverChildListDelegate(
                     [
                       Container(
                         padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 10),
                         child: Column(children: <Widget>[
                           Row(
                             children: [Provider.of<UserModel?>(context)?.
                               profileImageUrl != '' ? CircleAvatar(
                               radius: 20,
                               backgroundImage: NetworkImage(Provider.of<UserModel>(context).profileImageUrl)
                             ): const Icon(Icons.person,size: 50),
                               if(FirebaseAuth.instance.currentUser?.uid == uid)
                               TextButton(
                                   onPressed: () {
                                     Navigator.pushNamed(context, '/edit');
                                   },
                                   child: Container(
                                     padding: const EdgeInsets.symmetric(horizontal: 50),
                                       child: const Text("Edit Profile")))
                               else if(FirebaseAuth.instance.currentUser?.uid != uid && !Provider.of<bool>(context))
                               TextButton(
                                   onPressed: () {
                                      _userService.followUser(uid);
                                   },
                                   child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 50),
                                       child: const Text("Follow")))
                              else if(FirebaseAuth.instance.currentUser?.uid != uid && Provider.of<bool>(context))
                              TextButton(
                              onPressed: () {
                                _userService.unfollowUser(uid);
                                },
                              child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: const Text("UnFollow")))
                             ],
                         ),
                           Align(
                             alignment: Alignment.centerLeft,
                             child:Container(
                               padding: const EdgeInsets.symmetric(vertical: 10),
                               child: Text(
                                 Provider
                                     .of<UserModel?>(context)?.name ??
                                     '',
                                 style: const TextStyle(fontWeight: FontWeight.bold,
                                 fontSize: 25),
                               ),
                             ),
                           )
                         ],

                         ),

                       )
                     ]
                   ))

                ];
              }, body:const ListPosts()),
            )));
  }
}