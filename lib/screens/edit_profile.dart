import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/user.dart';

import 'package:recipe/services/database.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key, this.database}) : super(key: key);
  final Database database;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserData userData;
  String photoUrl;
  bool isLoading;
  File imageFile;
  final picker = ImagePicker();
  void getData() async {
    UserData data = await widget.database.getUserById();
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    print(userData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: userData?.userName);
    TextEditingController emailController =
        TextEditingController(text: userData?.email);
    TextEditingController mobileController =
        TextEditingController(text: userData?.mobile);
    TextEditingController bioController =
        TextEditingController(text: userData?.bio);
    TextEditingController locationController =
        TextEditingController(text: userData?.location);

    Future<void> _submit({@required String photoUrl}) async {
      // final auth = Provider.of<AuthBase>(context, listen: false);
      // final user = Provider.of<User>(context, listen: false);
      final id = userData?.id;
      // final database = Provider.of<Database>(context, listen: false);

      final data = UserData(
          userName: nameController.text,
          id: id,
          photoUrl: photoUrl,
          bio: bioController.text,
          mobile: mobileController.text.trim(),
          email: emailController.text.trim().toLowerCase(),
          location: locationController.text.trim().toLowerCase());

      widget.database.updateUserData(data);
    }

    void _clearController() {
      nameController.clear();
      emailController.clear();
      bioController.clear();
      mobileController.clear();
      locationController.clear();
    }

    void handleSubmit() async {
      // final database = Provider.of<Database>(context, listen: false);
      if (imageFile != null) {
        String url = await widget.database.uploadImageToStorage(imageFile);
        _submit(photoUrl: url);
      } else {
        _submit(photoUrl: userData.photoUrl);
      }

      // _clearController();
      setState(() {
        // _clearController();
        isLoading = false;
        imageFile = null;
        getData();
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
                if (snapshot.connectionState == ConnectionState.waiting &&
                    isLoading == true) {
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
                            hintText: "Name",
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
                            hintStyle: TextStyle(color: Colors.white),
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
                            hintText: "email",
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
                            hintStyle: TextStyle(color: Colors.white),
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
                            hintText: "mobile",
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
                            hintStyle: TextStyle(color: Colors.white),
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
                            hintStyle: TextStyle(color: Colors.white),
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
                            suffixStyle: TextStyle(color: Colors.white),
                            hintText: "bio",
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
                            hintStyle: TextStyle(color: Colors.white),
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
                              // values.removeWhere(
                              //     (key, value) => value.toString().startsWith('t'));
                              // setState(() {});
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
