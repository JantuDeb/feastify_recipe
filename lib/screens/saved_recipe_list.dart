import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/recipe_view.dart';
import 'package:recipe/services/auth.dart';
// import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';

// import 'package:recipe/services/firebase_transection.dart';

class SavedRecipeList extends StatefulWidget {
  @override
  _SavedRecipeListState createState() => _SavedRecipeListState();
}

class _SavedRecipeListState extends State<SavedRecipeList>
    with AutomaticKeepAliveClientMixin {
  bool keepAlive = true;
  TextStyle style1 = TextStyle(
      fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle style2 =
      TextStyle(fontSize: 13.0, color: Colors.white.withOpacity(0.7));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final database = Provider.of<Database>(context, listen: false);

    final user = Provider.of<User>(context, listen: false);
    void removeSaved(String id) {
      CollectionReference reference = Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection("saved_recipe");
      reference.document(id).delete();
    }

    return Container(
      color: Color(0xFF263238),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80.0,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Saved Recipes",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0)),
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      keepAlive = false;
                      updateKeepAlive();
                      setState(() {});
                      keepAlive = true;
                    })
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: database.getSavedRecipes(),
              builder: (context, snapshot) {
                List<Recipe> recipes = snapshot.data;
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                }
                if (recipes.length == 0) {
                  return Center(
                      child: Text("No Saved Recipe Found",
                          style: TextStyle(color: Colors.white)));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (BuildContext context, index) {
                      Recipe data = recipes[index];
                      return Container(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeView(
                                  database: database,
                                  recipe: data,
                                  user: user,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width * 0.36,
                                height: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.amber),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: snapshot.data == null
                                        ? AssetImage(
                                            'images/Searchpage-image3.jpg',
                                          )
                                        : NetworkImage(data.photoUrl),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.47,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.recipeTitle,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: style1,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("By Chef " + data.createdBy,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: style2),
                                    Container(
                                      margin: EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.deepOrange,
                                            size: 18.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "${data.viewCount}",
                                            style: style2,
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Icon(
                                            Icons.thumb_up,
                                            color: Colors.deepOrange,
                                            size: 18.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "${data.likeCount}",
                                            style: style2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: IconButton(
                                  icon: Image.asset(
                                    'images/icon/close.png',
                                    width: 12.0,
                                    height: 12.0,
                                  ),
                                  onPressed: () {
                                    removeSaved(data.id);
                                    keepAlive = false;
                                    updateKeepAlive();
                                    setState(() {});
                                    keepAlive = true;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Center(child: Text("No Saved Recipe Found"));
                // List<Recipe> recipes = snapshot.data;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}

/**
 * Container(
            height: 100.0,
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    try {
                      FirebaseTransection()
                          .getSavedRecipes('gJqahlhOyKPdGlJ6Iwh9ZpBr1vX2');
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width / 2.4,
                    child: Center(
                        child: Text(
                      "Shop Now",
                      style: style1,
                    )),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF2a6f7a)),
                  ),
                ),
                InkWell(
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
                        "Delete Selected",
                        style: style1,
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFFfd4f2d)),
                  ),
                )
              ],
            ),
          ),
 * 
 * 
 * 
 * 
 * 
 */
