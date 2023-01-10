import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_me/models/post.dart';
import 'package:social_me/services/posts.dart';
import 'package:social_me/services/user.dart';

import '../../../models/user.dart';

class ListPosts extends StatefulWidget {
  const ListPosts({super.key});

  @override
  State<ListPosts> createState() => _ListPostsState();
}

class _ListPostsState extends State<ListPosts> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<PostModel>?>(context) ?? [ ];
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context,index)
    {
      final post = posts[index];
      return StreamBuilder(
        stream: _userService.getUserInfo(post.creator),
        builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

                return ListTile(
                  title: Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Row(
                      children: [
                        snapshot.data?.profileImageUrl != '' ?
                        CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(snapshot.data!
                                .profileImageUrl))
                            : const Icon(Icons.person, size: 40),
                        const SizedBox(width: 10),
                        Text(snapshot.data!.name)
                      ],
                    ),

                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.text),
                            const SizedBox(height: 20),
                            Text(post.timestamp.toDate().toString()),
                            const SizedBox(height: 20),
                            IconButton(onPressed: (){
                              _postService.likePost(post, true);
                            },
                                icon: const
                                Icon(Icons.favorite_border,color: Colors.green,size: 30,))

                          ],

                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                );
              });
        },
      );
    }
  }