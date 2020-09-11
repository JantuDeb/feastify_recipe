import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/models/user.dart';

import 'package:recipe/services/database.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key, this.database, this.userData}) : super(key: key);
  final Database database;
  final UserData userData;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // UserData userData;
  String photoUrl;
  bool isLoading;
  File imageFile;
  final picker = ImagePicker();
  CollectionReference reference = Firestore.instance.collection("recipes");
  // void getData() async {
  //   UserData data = await widget.database.getUserById();
  //   setState(() {
  //     // userData = data;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // print(userData);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.userData?.userName);
    TextEditingController emailController =
        TextEditingController(text: widget.userData?.email);
    TextEditingController mobileController =
        TextEditingController(text: widget.userData?.mobile);
    TextEditingController bioController =
        TextEditingController(text: widget.userData?.bio);
    TextEditingController locationController =
        TextEditingController(text: widget.userData?.location);

    Future<void> _submit({@required String photoUrl}) async {
      // final auth = Provider.of<AuthBase>(context, listen: false);
      // final user = Provider.of<User>(context, listen: false);
      final id = widget.userData?.id;
      // final database = Provider.of<Database>(context, listen: false);

      final data = UserData(
          userName: nameController.text,
          id: id,
          photoUrl: photoUrl,
          bio: bioController.text,
          mobile: mobileController.text.trim(),
          email: emailController.text.trim().toLowerCase(),
          location: locationController.text.trim());

      widget.database
          .updateUserData(data)
          .then((value) => Navigator.pop(context));
      // if (userData.userName != nameController.text) {
      // reference.document(id).setData({'createdBy': nameController.text});
      // }
    }

    // void _clearController() {
    //   nameController.clear();
    //   emailController.clear();
    //   bioController.clear();
    //   mobileController.clear();
    //   locationController.clear();
    // }

    void handleSubmit() async {
      // final database = Provider.of<Database>(context, listen: false);
      if (imageFile != null) {
        String url = await widget.database.uploadImageToStorage(imageFile);
        _submit(photoUrl: url);
      } else {
        _submit(photoUrl: widget.userData.photoUrl);
      }

      // _clearController();
      setState(() {
        // _clearController();
        isLoading = false;
        imageFile = null;
        // getData();
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: Colors.orange[600],
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder<Object>(
              stream: widget.database.getUserById().asStream(),
              builder: (context, snapshot) {
                UserData user = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.connectionState == ConnectionState.none) {
                  return Text("user not found");
                }
                if (snapshot.hasData) {
                  var textStyle = TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold);
                  return ListView(
                    children: [
                      InkWell(
                        onTap: () async {
                          final pickedFile = await picker.getImage(
                              imageQuality: 50,
                              source: ImageSource.gallery,
                              maxHeight: 960,
                              maxWidth: 675);
                          setState(() {
                            if (pickedFile != null)
                              imageFile = File(pickedFile.path);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 40.0),
                          height: 91.0,
                          // alignment: Alignment.center,
                          width: 91.0,
                          child: CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: imageFile != null
                                ? ClipOval(
                                    child: Image.file(
                                    imageFile,
                                    fit: BoxFit.cover,
                                    width: 90.0,
                                    height: 90.0,
                                  ))
                                : ClipOval(
                                    child: user.photoUrl == null
                                        ? Image.asset(
                                            "images/profile_image.jpg",
                                            fit: BoxFit.cover,
                                            width: 90.0,
                                            height: 90.0,
                                          )
                                        : Image.network(
                                            user.photoUrl,
                                            fit: BoxFit.cover,
                                            width: 90.0,
                                            height: 90.0,
                                          ),
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: textStyle,
                            hintText: "Enter your name",
                            suffixStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            alignLabelWithHint: true,
                            // hintText: "${user.userName}",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: emailController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Email",
                            hintText: "Enter your email",
                            suffixStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            alignLabelWithHint: true,
                            // hintText: "${user.email}",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: mobileController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Mobile",
                            hintText: "Enter your mobile number",
                            suffixStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            alignLabelWithHint: true,
                            // hintText: "${user.mobile}",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          controller: locationController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "location",
                            labelStyle: textStyle,
                            labelText: "Location",
                            suffixStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            alignLabelWithHint: true,
                            // hintText: "${user.location}",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                          maxLines: 10,
                          minLines: 5,
                          controller: bioController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelStyle: textStyle,
                            labelText: "Bio",
                            suffixStyle: TextStyle(color: Colors.white),
                            hintText: "Add your Bio",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            alignLabelWithHint: true,
                            // hintText: "${user.bio}",
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            splashColor: Colors.white,
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 2.4,
                              child: Center(
                                  child: Text(
                                "Cancel",
                                style: textStyle,
                              )),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color(0xFFfd4f2d)),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(30.0),
                            splashColor: Colors.white,
                            onTap: () {
                              setState(() {
                                isLoading = true;
                                handleSubmit();
                              });
                            },
                            child: Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width / 2.4,
                              child: Center(
                                child: Text(
                                  "Saved",
                                  style: textStyle,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color(0xFF2a6f7a)),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                }
                return Text("${snapshot.error}");
              }),
        ),
      ),
    );
  }
}
