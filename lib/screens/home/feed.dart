import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_me/screens/main/posts/list.dart';
import 'package:social_me/services/posts.dart';
class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final PostService _postService = PostService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider.value(value: _postService.getFeed()
        , initialData: null,
      child:const Scaffold(body: ListPosts()));
  }
}