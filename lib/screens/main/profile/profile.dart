import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/screens/main/posts/list.dart';
import 'package:social_me/services/posts.dart';
import 'package:social_me/services/user.dart';

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
    return MultiProvider(
      providers: [
        StreamProvider.value(value:
        _postService.getPostsByUser(FirebaseAuth.instance.currentUser?.uid), initialData: null),
        StreamProvider.value(value:
        _userService.getUserInfo(FirebaseAuth.instance.currentUser?.uid),
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
                          .of<UserModel?>(context)?.bannerImageUrl ?? 'https://htmlcolorcodes.com/assets/images/colors/grass-green-color-solid-background-1920x1080.png' ,
                      fit: BoxFit.cover,
                      )),
                   ),
                   SliverList(delegate: SliverChildListDelegate(
                     [
                       Container(
                         padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                         child: Column(children: <Widget>[
                           Row(

                           children: [
                             Image.network(Provider
                                 .of<UserModel?>(context)?.profileImageUrl ??
                                 'https://htmlcolorcodes.com/assets/images/colors/grass-green-color-solid-background-1920x1080.png',
                               height: 70,
                               width: 65,
                               fit: BoxFit.cover,
                             ),
                             TextButton(

                                 onPressed:()
                             {
                               Navigator.pushNamed(context, '/edit');
                             },
                                 child: Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 80),
                                   child: const Text('Edit profile'),
                                 ))
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