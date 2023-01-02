import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostModel{
  final String id;
  final String creator;
  final String text;
  final Timestamp timestamp;

  PostModel({ required this.id,required this.creator,required this.text,required this.timestamp});
}