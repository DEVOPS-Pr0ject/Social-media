
import 'package:flutter/material.dart';
import 'package:social_me/services/posts.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final PostService _postService = PostService();
  String text = ' ';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tweet"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () async{
              _postService.savePost(text);
              Navigator.pop(context);
            },
            child: const Icon(Icons.done),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Form(
            child: TextFormField(
              decoration:const InputDecoration(
                  label: Text("Let's tweet!!" ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: Colors.black),

                  )
              ),
              onChanged: (val){
                setState(() {
                  text = val;
                });
              },
            )),
      ),
    );
  }
}