import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/recipe_view.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/firebase_transection.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  TextStyle headerTextStyle = TextStyle(
      color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold);

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final database = Provider.of<Database>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    return Container(
      color: Color(0xFF263238),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Latest Racipe",
                      style: headerTextStyle,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  height: 150,
                  child: LatestRecipe(database, user),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            // height: 250.0,
            child: CarouselWithIndicatorDemo(),
          ),
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text(
                    "Most Liked Recipe",
                    style: headerTextStyle,
                  ),
                ),
                Container(
                    height: 150,
                    child: CustomList(
                      database: database,
                      user: user,
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class LatestRecipe extends StatefulWidget {
  LatestRecipe(this.database, this.user);
  final Database database;
  final User user;

  @override
  _LatestRecipeState createState() => _LatestRecipeState();
}

class _LatestRecipeState extends State<LatestRecipe> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
        stream: widget.database.readRecipe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Text("error:${snapshot.error}");
          }
          if (snapshot.data.length == 0) {
            return Container(
              child: Center(
                  child: Text(
                "No Recipes for todays",
                style: TextStyle(color: Colors.white),
              )),
            );
          }
          if (!snapshot.hasData) {
            return Center(child: Text("No Data"));
          } else {
            final recipes = snapshot.data;
            return ListView.builder(
              itemCount: recipes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    try {
                      FirebaseTransection().updateView(recipes[index].id);
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
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            recipes[index].photoUrl,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 150,
                          ),
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
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                'Recipe By ${recipes[index].createdBy}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
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
          }
        });
  }
}

class CarouselWithIndicatorDemo extends StatelessWidget {
  // final List<String> imgList = [];
  // Future<void> _getCarouselImages() async {
  //   await _reference.getDocuments().then((QuerySnapshot snapshot) {
  //     if (snapshot.documents.isNotEmpty) {
  //       for (int i = 0; i < snapshot.documents.length; i++) {
  //         // DocumentSnapshot snap = snapshot.documents[i];
  //         imgList.add(snapshot.documents[i].data["link"]);
  //       }
  //       setState(() {});
  //     }
  //   });
  // }

  // @override
  // void dispose() {

  //   // _getCarouselImages();
  //   super.dispose();
  // }

  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _getCarouselImages();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference _reference =
        Firestore.instance.collection("image_carousel");
    int _current = 0;

    // final List<Widget> imageSliders = imgList
    //     .map((item) => Container(
    //           child: Container(
    //             // margin: EdgeInsets.all(5.0),
    //             child: ClipRRect(
    //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //                 child: Stack(
    //                   children: <Widget>[
    //                     // Image.network(item, fit: BoxFit.cover, width: 1000.0),
    //                     Image(
    //                       image: CachedNetworkImageProvider(item),
    //                       fit: BoxFit.cover,
    //                       width: 400,
    //                     )
    //                   ],
    //                 )),
    //           ),
    //         ))
    //     .toList();

    return StreamBuilder<QuerySnapshot>(
        stream: _reference.snapshots(),
        builder: (context, snapshot) {
          List<Widget> slider = List<Widget>();
          _buidWidget(String link) {
            return Container(
              key: UniqueKey(),
              // margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      // Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Image(
                        image: CachedNetworkImageProvider(link),
                        fit: BoxFit.cover,
                        width: 400,
                      )
                    ],
                  )),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            for (int i = 0; i < snapshot.data.documents.length; i++) {
              // DocumentSnapshot snap = snapshot.documents[i];
              // imgList.add(snapshot.data.documents[i].data["link"]);
              slider.add(_buidWidget(snapshot.data.documents[i].data["link"]));
            }
          }

          return Column(
            children: [
              // imgList.length == 0
              //     ? Container(
              //         // height: 150,
              //         child: Center(
              //           child: CircularProgressIndicator(),
              //         ),
              //       )
              //     :
              Container(
                // height: 150,
                child: CarouselSlider(
                  items: slider,
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.3,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        _current = index;
                        print(_current);
                        // });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: slider.map((url) {
                  int index = slider.indexOf(url);
                  return Container(
                    width: _current == index ? 10.0 : 8.0,
                    height: _current == index ? 10.0 : 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Colors.white
                          : Colors.white.withAlpha(100),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        });
  }
}

class CustomList extends StatelessWidget {
  const CustomList({Key key, @required this.database, @required this.user})
      : super(key: key);
  final Database database;
  final User user;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Recipe>>(
      stream: database.readRecipeByLike(),
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
                    FirebaseTransection().updateView(recipes[index].id);
                  } catch (e) {
                    print(e);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeView(
                        database: database,
                        recipe: recipes[index],
                        user: user,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Stack(
                    children: <Widget>[
                      recipes[index].photoUrl != null
                          ? Image.network(recipes[index].photoUrl,
                              width: 200, height: 150, fit: BoxFit.cover)
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
    );
  }
}
