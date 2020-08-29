import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/edit_profile.dart';

import 'package:recipe/screens/edit_recipe.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({Key key, this.postId}) : super(key: key);
  final String postId;
  @override
  Widget build(BuildContext context) {
    TextStyle style1 = TextStyle(color: Colors.white, fontSize: 18.0);
    final database = Provider.of<Database>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    return Container(
      color: Color(0xFF263238),
      child: ListView(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditProfile(
                                database: database,
                              ))),
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    width: 100.0,
                    height: 40.0,
                    child: Center(
                        child: postId == null
                            ? Text(
                                "Edit Profile",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Follow",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              )),
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
                  width: 80.0, //MediaQuery.of(context).size.width * 0.2,/*/
                  // decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(50.0)),
                  child: CircleAvatar(
                    child: ClipOval(
                      child: user.photoUrl == null
                          ? Image.asset(
                              "images/profile_image.jpg",
                              fit: BoxFit.cover,
                              width: 90.0,
                              height: 90.0,
                            )
                          : Image.network(user.photoUrl),
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
                          "${user.displayName}",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "India",
                          style: TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        Text(
                          "Description",
                          style: style1,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xFF3c68e3),
                  child: Container(
                    child: Center(
                        child: Text(
                      " 1564 Followers",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15.0),
                    )),
                    width: 160.0,
                    height: 50.0,
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Color(0xFF44cbf5),
                  child: Container(
                    width: 160.0,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        " 536 Following",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
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
                } else {
                  return Column(
                    children: snapshot.data
                        .map(
                          (snapshot) => Card(
                            child: Container(
                              height: 250.0,
                              child: Column(
                                children: <Widget>[
                                  Container(
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
                                            ],
                                          ),
                                        )
                                      ],
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
                }
              },
            ),
          )

          /*
          Column(
            children: <Widget>[
              
              
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: Card(
                  child: Container(
                    height: 200.0,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          height: 150.0,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Image(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage('images/ProfileView-image2.jpg'),
                              ),
                              Container(
                                color: Colors.black.withOpacity(0.3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Title",
                                      style: style1,
                                    ),
                                    Text(
                                      "Description",
                                      style: style1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
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
                              child: Container(
                                color: Color(0xFF1b2327),
                                height: 50.0,
                                child: Center(
                                    child: Text(
                                  "Delete",
                                  style: style1,
                                )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )*/
          // Expanded(
          //     child: ListView(
          //   children: <Widget>[],
          // ))
        ],
      ),
    );
  }
}
