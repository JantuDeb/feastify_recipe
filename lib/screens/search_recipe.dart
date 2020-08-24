import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchRecipe extends StatefulWidget {
  @override
  _SearchRecipeState createState() => _SearchRecipeState();
}

class _SearchRecipeState extends State<SearchRecipe> {
  String queryString;
  TextEditingController searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF263238),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: Color(0xFF263238),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) => initiateQuery(value),
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                  autofocus: true,
                  controller: searchTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: queryString != null && queryString != ''
                      ? Firestore.instance
                          .collection("recipes")
                          .where("searchQuery",
                              arrayContains: queryString.toLowerCase())
                          .snapshots()
                      : null,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text("Error: ${snapshot.error}"));
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                        ),
                      );
                    if (snapshot.connectionState == ConnectionState.none)
                      return Center(
                        child: Text("No Recipes to show",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      );
                    if (snapshot.data.documents.isEmpty)
                      return Center(
                          child: Text("Search with valid recipe Title",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0)));
                    return ListView(
                      children: snapshot.data.documents
                          .map((document) => _buildRow(
                              avatarImage: document['photoUrl'],
                              name: document['recipeTitle'],
                              recipeDes: document['recipeDescription'],
                              context: context))
                          .toList(),
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

  initiateQuery(String value) {
    setState(() {
      queryString = value;
    });
  }
}

Widget _buildRow({String avatarImage, String name, String recipeDes, context}) {
  return Container(
    height: 110.0,
    child: Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8.0),
          width: MediaQuery.of(context).size.width * 0.35,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.amber),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image(
              fit: BoxFit.cover,
              image: NetworkImage(
                avatarImage,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.55,
          margin: EdgeInsets.only(right: 8.0, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                recipeDes,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
