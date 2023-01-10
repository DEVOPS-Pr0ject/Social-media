import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_me/models/post.dart';
import 'package:social_me/services/user.dart';
import 'package:quiver/iterables.dart';
class PostService {
  List<PostModel> _postListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return PostModel(
        id: doc.id,
        text: (doc.data() as dynamic)['text'] ?? '',
        creator: (doc.data() as dynamic)['creator'] ?? '',
        timestamp: (doc.data() as dynamic)['timestamp'] ?? 0,
      );
    }).toList();
  }
  Future savePost(text) async {
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'creator': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
  Future likePost(PostModel post,bool current) async {
    print(post.id);
    if(current){
      await FirebaseFirestore.instance.collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }
    if(!current){
      await FirebaseFirestore.instance.collection("posts")
          .doc(post.id)
          .collection("likes")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});
    }

  }


    Stream<List<PostModel>>getPostsByUser(uid){
      return FirebaseFirestore.instance.collection("posts")
          .where('creator' , isEqualTo: uid)
          .snapshots()
          .map(_postListFromSnapshot);

  }

  Future<List<PostModel>?> getFeed() async{
    List<String>? usersFollowing = await UserService() //['uid1','uid2']
        .getUserFollowing(FirebaseAuth.instance.currentUser?.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing!,10);
    inspect(splitUsersFollowing);
  List<PostModel> feedList = [];
    for(int i=0; i < splitUsersFollowing.length; i++){
      inspect(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    .collection("posts")
    .where("creator" , whereIn: splitUsersFollowing.elementAt(i))
    .orderBy("timestamp", descending: true)
    .get();
      feedList.addAll(_postListFromSnapshot(querySnapshot));
    }
    feedList.sort((a,b){
    var adate = a.timestamp;
    var bdate = b.timestamp;
    return bdate.compareTo(adate);
    });
    return feedList;

  }
}