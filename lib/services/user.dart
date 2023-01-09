import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/services/utils.dart';

class UserService{
   final UtilsService _utilsService = UtilsService();
  List<UserModel>_userListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return UserModel(id: doc.id,
        name: (doc.data() as dynamic )['name'] ?? '',
        profileImageUrl: (doc.data() as dynamic)['profileImageUrl'] ?? '',
        bannerImageUrl: (doc.data() as dynamic)['bannerImageUrl'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',);
    }).toList();
  }
  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot){
    return snapshot != null
        ? UserModel(id: snapshot.id,
      name: (snapshot.data() as dynamic)['name'] ?? '',
      profileImageUrl: (snapshot.data() as dynamic)['profileImageUrl'] ?? '',
      bannerImageUrl: (snapshot.data() as dynamic)['bannerImageUrl'] ?? '',
      email: (snapshot.data() as dynamic)['email'] ?? '',
    )
        : null;

  }
  Future<List<String>?> getUserFollowing(uid) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();

    final users = querySnapshot.docs.map((doc) => doc.id).toList();
    return users;
  }
  Stream<List<UserModel>?>queryByName(search){
    return FirebaseFirestore.instance.collection("users")
        .orderBy("name")
        .startAt([search])
        .endAt([search + '\uf8ff'])
        .limit(4)
        .snapshots()
        .map(_userListFromQuerySnapshot);
  }
  Stream<UserModel?> getUserInfo(uid){
    return FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }
   Stream<bool> isFollowing(uid,otherId) {
     return FirebaseFirestore.instance.collection("users")
         .doc(uid)
         .collection("following")
         .doc(otherId)
         .snapshots()
         .map((snapshot) {
           return snapshot.exists;
     });
   }
    Future<void> followUser(uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('following')
        .doc(uid)
        .set({});
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followers")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});
    }
   Future<void> unfollowUser(uid) async {
     await FirebaseFirestore.instance
         .collection("users")
         .doc(FirebaseAuth.instance.currentUser?.uid)
         .collection("following")
         .doc(uid)
         .delete();
     await FirebaseFirestore.instance
         .collection("users")
         .doc(uid)
         .collection("followers")
         .doc(FirebaseAuth.instance.currentUser?.uid)
         .delete();
   }

  Future<void> updateProfile(File bannerImage,File profileImage, String name)
  async{
    String bannerImageUrl=' ';
    String profileImageUrl=' ';
    bannerImageUrl =  await _utilsService.uploadFiles(bannerImage,
        'users/profile/${FirebaseAuth.instance.currentUser?.uid}/banner');
    profileImageUrl =  await _utilsService.uploadFiles(profileImage,
        'users/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');
    Map<String,Object> data = HashMap();
    if (name !='') data['name'] = name;
    if(bannerImageUrl !=' ') data['bannerImageUrl'] = bannerImageUrl;
    if(profileImageUrl !=' ') data['profileImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(data);
    return ;

  }


}