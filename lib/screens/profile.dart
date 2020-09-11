import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/followers.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/models/user.dart';
import 'package:recipe/screens/edit_profile.dart';

import 'package:recipe/screens/edit_recipe.dart';
import 'package:recipe/screens/recipe_view.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/firebase_transection.dart';

import 'follow.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile>
    with AutomaticKeepAliveClientMixin {
  // UserData userData;

  // void getData() async {
  //   Database database = Provider.of<Database>(context, listen: false);
  //   UserData data = await database.getUserById();
  //   setState(() {
  //     userData = data;
  //   });
  // }

  @override
  void initState() {
    // print(userData);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getData();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TextStyle style1 = TextStyle(color: Colors.white, fontSize: 18.0);
    final database = Provider.of<Database>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    void reload() {
      setState(() {});
    }

    // String id = widget.ownerId == null ? user.uid : widget.ownerId;
    return Container(
      color: Color(0xFF263238),
      child: ListView(
        children: <Widget>[
          FutureBuilder(
            future: database.getUserById(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 140,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              UserData _user = snapshot.data;
              return Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => snapshot.data != null
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EditProfile(
                                            database: database,
                                            userData: _user,
                                          ))).then((value) {
                                  reload();
                                })
                              : null,
                          child: Container(
                            margin: EdgeInsets.all(15.0),
                            width: 100.0,
                            height: 40.0,
                            child: Center(
                                child:
                                    // widget.ownerId == null
                                    Text(
                              "Edit Profile",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )
                                // : Text(
                                //     "Follow",
                                //     style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 16.0,
                                //         fontWeight: FontWeight.bold),
                                //   )
                                ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(50.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 30.0, right: 10.0),
                          height: 80.0,
                          width:
                              80.0, //MediaQuery.of(context).size.width * 0.2,/*/
                          // decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(50.0)),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: snapshot.data.photoUrl == null
                                  ? Image.asset(
                                      "images/profile_image.jpg",
                                      fit: BoxFit.cover,
                                      width: 90.0,
                                      height: 90.0,
                                    )
                                  : Image(
                                      image: CachedNetworkImageProvider(
                                          _user.photoUrl),
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  "${_user.userName}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${_user.location}",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF3c68e3),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Following(
                                          database: database,
                                          // followers: snapshot.data
                                          //     .map((snapshot) =>
                                          //         Followers.fromFollowersMap(
                                          //             snapshot.data,
                                          //             snapshot.documentID))
                                          //     .toList(),
                                          currentIndex: 0,
                                        )));
                          },
                          child: Container(
                            child: Center(
                                child: Text(
                              "${_user.followersCount} Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15.0),
                            )),
                            width: 160.0,
                            height: 50.0,
                          ),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF44cbf5),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Following(
                                          database: database,
                                          user: user,
                                          // followers: snapshot.data
                                          //     .map((snapshot) =>
                                          //         Followers.fromFollowersMap(
                                          //             snapshot.data,
                                          //             snapshot.documentID))
                                          //     .toList(),
                                          currentIndex: 1,
                                        )));
                          },
                          child: Container(
                            width: 160.0,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "${_user.followingCount} Following",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: Color(0xFF192024),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: _user.bio == null
                          ? Text("Please Update your Bio ")
                          : Text(
                              "${_user.bio}",
                              style: style1,
                            ),
                    ),
                  )
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Container(
              height: 50.0,
              child: Text(
                "My Recipes",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          Container(
            child: StreamBuilder<List<Recipe>>(
              stream: database.readUserRecipe(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("${snapshot.error}");
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 0.0,
                            style: BorderStyle.solid)),
                    height: 250.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Recipes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                        Image.asset(
                          'images/recipe.png',
                          height: 100,
                          width: 100,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 20.0, bottom: 2.0),
                          child: Text(
                            "Write and share your recipe with others ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.w400,
                                fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "You can see all the Recipes you have created here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Column(
                  children: snapshot.data
                      .map(
                        (snapshot) => Card(
                          child: Container(
                            height: 250.0,
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    try {
                                      FirebaseTransection()
                                          .updateView(snapshot.id);
                                    } catch (e) {
                                      print(e);
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipeView(
                                          database: database,
                                          recipe: snapshot,
                                          user: user,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: double.maxFinite,
                                    height: 200.0,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Image(
                                          fit: BoxFit.cover,
                                          image: snapshot.photoUrl == null
                                              ? AssetImage(
                                                  'images/ProfileView-image2.jpg')
                                              : NetworkImage(snapshot.photoUrl),
                                        ),
                                        Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "${snapshot.recipeTitle}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Center(
                                                child: Text(
                                                  " ${snapshot.recipeDescription}",
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: style1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye,
                                                    color: Colors.orange,
                                                    size: 18.0,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    "${snapshot.viewCount}",
                                                    style: style1,
                                                  ),
                                                  SizedBox(
                                                    width: 20.0,
                                                  ),
                                                  Icon(
                                                    Icons.thumb_up,
                                                    color: Colors.orange,
                                                    size: 18.0,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    "${snapshot.likeCount}",
                                                    style: style1,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditRecipe(
                                                recipe: snapshot,
                                                mContext: context,
                                                user: user,
                                                database: database),
                                          ),
                                        ),
                                        child: Container(
                                          color: Color(0xFFfd4f2d),
                                          height: 50.0,
                                          child: Center(
                                              child: Text(
                                            "Edit",
                                            style: style1,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Color(0xFF2a6f7a),
                                        height: 50.0,
                                        child: Center(
                                            child: Text(
                                          "Share",
                                          style: style1,
                                        )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () async {
                                          await database
                                              .removeDocument(snapshot.id);
                                        },
                                        child: Container(
                                          color: Color(0xFF1b2327),
                                          height: 50.0,
                                          child: Center(
                                              child: Text(
                                            "Delete",
                                            style: style1,
                                          )),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
