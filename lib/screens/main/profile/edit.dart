
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_me/services/user.dart';
class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final UserService _userService = UserService();
       File? profileImage  ;
       File? bannerImage ;
  final picker = ImagePicker();
  String name='';
   Future getImage(int type) async{
     final pickedFile = await picker.pickImage(source: ImageSource.camera);
     setState(() {
       if(pickedFile !=null && type == 0){
         profileImage = File(pickedFile.path);
       }
       if(pickedFile !=null && type == 1){
         bannerImage = File(pickedFile.path);
       }
     });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(onPressed: () async{
            _userService.updateProfile(bannerImage??File('path'), profileImage??File(''), name);
            Navigator.pop(context);
          }, child:const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
            child: Column(
              children: [
                TextButton(onPressed: () => getImage(0),
                  child: profileImage== null?
                    const Icon(Icons.person_pin) : Image.file(profileImage??File('  '),height:100),),
                TextButton(onPressed: () => getImage(1),
                  child: bannerImage== null?
                  const Icon(Icons.camera_alt_rounded) : Image.file(bannerImage??File(' '),height:100),),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text('Enter Your Name')
                  ),
                onChanged: (val) => setState(() {
                  name =val;
                }),
              )],
            )
        ),
      ),
    );
  }

  }
