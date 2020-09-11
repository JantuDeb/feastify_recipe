import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/models/user.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/firebase_transection.dart';

import 'other_user_profile.dart';

class RecipeView extends StatefulWidget {
  const RecipeView({
    Key key,
    this.database,
    this.recipe,
    this.user,
  }) : super(key: key);
  final Database database;
  final Recipe recipe;
  final User user;

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  UserData userData;

  bool tapped = false;
  int likeCount;
  bool isLiked = false;
  bool isSaved = false;
  bool isFollowing = false;
  CollectionReference reference = Firestore.instance.collection("recipes");
  void getData() async {
    try {
      UserData data = await widget.database.getUserById();
      setState(() {
        userData = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      savedOrNot();
      _isFollowing();
    });
    getLikeCount(widget.recipe.likes);
  }

  void getLikeCount(var likes) {
    if (likes == null) {
      likeCount = 0;
    } else {
      var vals = likes.values;
      int count = 0;
      for (var val in vals) {
        if (val == true) {
          count = count + 1;
        }
      }
      likeCount = count;
    }
    if (likes[widget.recipe.recipeId] == true) {
      isLiked = true;
    }
  }

  void _likePost() {
    var likes = widget.recipe.likes;
    bool _liked = likes[widget.user.uid] == true;
    print(widget.user.uid);
    print(widget.recipe.id);
    if (_liked) {
      print('removing like');
      try {
        reference
            .document(widget.recipe.id)
            .updateData({'likes.${widget.user.uid}': false});
        setState(() {
          likeCount = likeCount - 1;
          isLiked = false;
          likes[widget.user.uid] = false;
        });
        reference
            .document(widget.recipe.id)
            .updateData({'likeCount': likeCount});
      } on Exception catch (e) {
        print(e);
      }
    }

    if (!_liked) {
      print('liking');
      try {
        reference
            .document(widget.recipe.id)
            .updateData({'likes.${widget.user.uid}': true});

        setState(() {
          likeCount = likeCount + 1;
          isLiked = true;
          likes[widget.user.uid] = true;
          // showHeart = true;
        });
        reference
            .document(widget.recipe.id)
            .updateData({'likeCount': likeCount});
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  void savedOrNot() async {
    try {
      CollectionReference reference = Firestore.instance
          .collection('users')
          .document(widget.user.uid)
          .collection("saved_recipe");

      DocumentSnapshot snapshot =
          await reference.document(widget.recipe.id).get();
      if (snapshot.exists) {
        setState(() {
          isSaved = true;
        });
      } else {
        setState(() {
          isSaved = false;
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void savedRecipe() async {
    setState(() {
      isSaved = !isSaved;
    });
    try {
      CollectionReference reference = Firestore.instance
          .collection('users')
          .document(widget.user.uid)
          .collection("saved_recipe");
      DocumentSnapshot snapshot =
          await reference.document(widget.recipe.id).get();
      if (snapshot.exists) {
        reference.document(widget.recipe.id).delete();
      } else {
        reference
            .document(widget.recipe.id)
            .setData({'createdAt': Timestamp.now()}, merge: true);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  _isFollowing() async {
    try {
      bool _isFollowing =
          await widget.database.checkIsFollowing(widget.recipe.recipeId);
      setState(() {
        isFollowing = _isFollowing;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(isFollowing);
    // isLiked = widget.recipe.likes[widget.user.uid] = true;
    double screenWidth = MediaQuery.of(context).size.width;
    TextStyle style1 = TextStyle(color: Colors.white, fontSize: 18.0);
    TextStyle style2 = TextStyle(color: Colors.white, fontSize: 16.0);

    Color iconColor = Colors.white;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: Container(
          color: Color(0xFF263238),
          child: ListView(
            children: <Widget>[
              Container(
                height: 200.0,
                width: screenWidth,
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  Image(
                    image: widget.recipe.photoUrl != null
                        ? NetworkImage(widget.recipe.photoUrl)
                        : AssetImage('images/Searchpage-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: IconButton(
                        iconSize: 50.0,
                        icon: Image(
                          image: AssetImage('images/youtube.png'),
                        ),
                        onPressed: null),
                  ),
                ]),
              ),
              Container(
                height: 70.0,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.0,
                        color: Colors.grey,
                        style: BorderStyle.solid)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                              "$likeCount",
                              style: TextStyle(color: Colors.white),
                            )),
                            SizedBox(
                              height: 4.0,
                            ),
                            InkWell(
                              onTap: () => _likePost(),
                              child: Icon(Icons.thumb_up,
                                  color: isLiked ? Colors.blue : Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "${widget.recipe.viewCount}",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Icon(Icons.remove_red_eye, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "2523",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            InkWell(
                              onTap: () async {
                                try {
                                  savedRecipe();
                                  // savedRecipe();
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: Icon(Icons.favorite,
                                  color: isSaved ? Colors.red : Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              FutureBuilder(
                  future:
                      widget.database.getUserById(id: widget.recipe.recipeId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }

                    return Container(
                      height: 100.0,
                      color: Color(0xFF262626),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10.0),
                            width: 60.0,
                            height: 60.0,
                            child: InkWell(
                              onTap: () =>
                                  widget.user.uid != widget.recipe.recipeId
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OtherProfile(
                                              ownerId: widget.recipe.recipeId,
                                              user: widget.user,
                                              database: widget.database,
                                            ),
                                          ),
                                        )
                                      : null,
                              child: CircleAvatar(
                                child: ClipOval(
                                  child: snapshot.data.photoUrl != null
                                      ? Image(
                                          image: CachedNetworkImageProvider(
                                            snapshot.data.photoUrl,
                                          ),
                                          fit: BoxFit.cover,
                                          width: 90.0,
                                          height: 90.0,
                                        )
                                      : Image.asset(
                                          "images/profile_image.jpg",
                                          fit: BoxFit.cover,
                                          width: 90.0,
                                          height: 90.0,
                                        ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${snapshot.data.userName}",
                                  style: style1,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "${snapshot.data.location}",
                                  style: style2,
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  if (!isFollowing) {
                                    try {
                                      widget.database.followUser(
                                          name: widget.user.displayName,
                                          followingName: snapshot.data.userName,
                                          followingUserId:
                                              widget.recipe.recipeId,
                                          photoUrl: userData.photoUrl,
                                          followingPhotoUrl:
                                              snapshot.data.photoUrl);
                                      FirebaseTransection().updateFollow(
                                          userData.id, widget.recipe.recipeId);
                                      print("following");
                                    } on Exception catch (e) {
                                      print(e);
                                    }
                                  } else {
                                    widget.database.unFollowUser(
                                        followingUserId:
                                            widget.recipe.recipeId);
                                    FirebaseTransection().updateUnFollow(
                                        userData.id, widget.recipe.recipeId);
                                  }
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                child: widget.user.uid != widget.recipe.recipeId
                                    ? Container(
                                        height: 40.0,
                                        width: 100.0,
                                        margin: EdgeInsets.only(right: 30.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.white)),
                                        child: Center(
                                            child: !isFollowing
                                                ? Text(
                                                    "Follow",
                                                    style: style1,
                                                  )
                                                : Text(
                                                    "Unfollow",
                                                    style: style1,
                                                  )),
                                      )
                                    : Container(),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              Container(
                margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 30.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.recipe.recipeTitle}",
                      style: style1,
                    ),
                    Spacer(),
                    IconButton(
                        iconSize: 20.0,
                        icon: Image(
                          image: AssetImage('images/share.png'),
                          color: Colors.white,
                          width: 20.0,
                        ),
                        onPressed: null)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "${widget.recipe.recipeDescription}",
                  style: style2,
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                height: 50.0,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: widget.recipe.categories
                        .map((category) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                elevation: 5.0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 5.0,
                                      left: 10.0,
                                      right: 10.0),
                                  child: Center(
                                    child: Text(category,
                                        style: TextStyle(fontSize: 18.0)),
                                  ),
                                ),
                              ),
                            ))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Serves  ${widget.recipe.serves}",
                                style: style2),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Cooking Time ${widget.recipe.cookingTime}",
                              style: style2,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ingredients",
                        style: style1,
                      ),
                    ),
                    Column(
                      children: widget.recipe.ingredients
                          .map((item) => ListTile(
                                onTap: () {
                                  setState(() {
                                    tapped = true;
                                  });
                                },
                                trailing: !tapped
                                    ? Icon(
                                        Icons.add_circle,
                                        color: iconColor,
                                      )
                                    : Icon(
                                        Icons.add_circle,
                                        color: Colors.blue,
                                      ),
                                title: Text(
                                  item,
                                  style: style2,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Methods",
                        style: style1,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.recipe.methods
                          .map((item) => ListTile(
                                contentPadding:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                title: Text(
                                  item,
                                  style: style2,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.white.withAlpha(50),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "Recomended Recipes",
                  style: style1.apply(fontSizeFactor: 1.1),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8.0, left: 8.0),
                height: 150.0,
                child: StreamBuilder(
                  stream: widget.database.readRecomendedRecipes(),
                  builder: (context, snapshot) {
                    List<Recipe> recipes = snapshot.data;
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 200,
                          margin: EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              try {
                                FirebaseTransection()
                                    .updateView(recipes[index].id);
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeView(
                                    database: widget.database,
                                    recipe: recipes[index],
                                    user: widget.user,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              child: Stack(
                                children: <Widget>[
                                  recipes[index].photoUrl != null
                                      ? Image.network(recipes[index].photoUrl,
                                          width: 200,
                                          height: 150,
                                          fit: BoxFit.cover)
                                      : Container(),
                                  Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(200, 0, 0, 0),
                                            Color.fromARGB(0, 0, 0, 0)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      child: Text(
                                        " Recipe By ${recipes[index].createdBy}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.search,
              size: 30.0,
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body:
*/
