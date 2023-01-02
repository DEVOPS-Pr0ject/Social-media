import 'dart:collection';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/services/utils.dart';

class UserService{
  final UtilsService _utilsService = UtilsService();
  UserModel? _userFromFirebaseSnapshot(DocumentSnapshot snapshot){
    return snapshot != null
        ? UserModel(id: snapshot.id,
            name: (snapshot.data() as dynamic)['name'],
            profileImageUrl: (snapshot.data() as dynamic)['profileImageUrl'],
            bannerImageUrl: (snapshot.data() as dynamic)['bannerImageUrl'],
            email: (snapshot.data() as dynamic)['email'],
        )
        : null;

  }

    Stream<UserModel?> getUserInfo(uid){
    return FirebaseFirestore.instance.collection("users")
        .doc(uid)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
    }
  Future<void> updateProfile(File bannerImage,File profileImage, String name)
  async{
    String bannerImageUrl='';
    String profileImageUrl='';
    if(bannerImage != null){
      // save to storage
      bannerImageUrl =  await _utilsService.uploadFiles(bannerImage,
          'users/profile/${FirebaseAuth.instance.currentUser?.uid}/banner');
    }
    if(profileImage != null){
      // save to storage
      profileImageUrl = await _utilsService.uploadFiles(profileImage,
          'users/profile/${FirebaseAuth.instance.currentUser?.uid}/profile');
    }
   Map<String,Object> data = HashMap();
   if (name !='') data['name'] = name;
    if(bannerImageUrl !='') data['bannerImageUrl'] = bannerImageUrl;
    if(profileImageUrl !='') data['profileImageUrl'] = profileImageUrl;

    await FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser?.uid)
    .update(data);
    return ;

  }
}