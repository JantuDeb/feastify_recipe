import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/add_categories.dart';
import 'package:recipe/services/auth.dart';
// import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
// import 'package:reorderables/reorderables.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key key, this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  List<String> _ingredients = [];
  List<String> _methods = [];
  Set<String> categories = {};
  File _imageFile;
  String _imageUrl;
  final picker = ImagePicker();
  List<String> searchList = List();

  //Controllers
  final recipeIngredientsController = TextEditingController();
  final recipeMethodsController = TextEditingController();
  final recipeTitleController = TextEditingController();
  final recipeDesController = TextEditingController();
  final recipeLinkController = TextEditingController();
  final recipeServesController = TextEditingController();
  final recipeCookingTimeController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    recipeIngredientsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  function(value) {
    categories = value;
    setState(() {});
  }

  Future<void> _submit() async {
    print(recipeTitleController.text.length);
    setSearchParam(recipeTitleController.text);
    // final auth = Provider.of<AuthBase>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    final id = widget.recipe?.id ?? documentIdFromDTN();
    final database = Provider.of<Database>(context, listen: false);
    final recipe = Recipe(
        id: id,
        photoUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        recipeTitle: recipeTitleController.text,
        createdBy: user.displayName,
        categories: categories.toList(),
        methods: _methods,
        ingredients: _ingredients,
        recipeId: user.uid,
        recipeDescription: recipeDesController.text,
        serves: recipeServesController.text,
        recipeLink: recipeLinkController.text,
        cookingTime: recipeCookingTimeController.text,
        searchQuery: searchList,
        createdAt: Timestamp.now());
    await database.createRecipe(recipe);
    setState(() {
      _clearController();
      isLoading = false;
    });
  }

  // Future _getLocaleImage(String s) async {
  //   if (s == "camera") {
  //     final pickedFile = await picker.getImage(source: ImageSource.camera);
  //     setState(() {
  //       if (pickedFile != null) _imageFile = File(pickedFile.path);
  //     });
  //   } else {
  //     final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //     setState(() {
  //       if (pickedFile != null) _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }
  void _clearController() {
    recipeIngredientsController.clear();
    recipeMethodsController.clear();
    recipeTitleController.clear();
    recipeDesController.clear();
    recipeLinkController.clear();
    recipeServesController.clear();
    recipeCookingTimeController.clear();
    _ingredients.clear();
    _methods.clear();
    categories.clear();
    _imageFile = null;
    _imageUrl = null;
    searchList.clear();
  }

  void isValid() {
    if (_ingredients.length >= 1 &&
            _methods.length >= 1 &&
            categories.length >= 1 &&
            recipeTitleController.text.length >= 5 &&
            recipeDesController.text.length >= 10 &&
            recipeServesController.text.isNotEmpty &&
            recipeCookingTimeController.text.length >= 3
        // &&_imageUrl != null
        ) {
      _submit();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> setSearchParam(String recipeTitle) {
    String temp = "";
    for (int i = 0; i < recipeTitle.length; i++) {
      temp = temp + recipeTitle[i].toLowerCase();
      searchList.add(temp);
    }
    return searchList;
  }

  @override
  Widget build(BuildContext context) {
    void addIngredients(String ingredient) {
      if (ingredient.isNotEmpty) {
        print(ingredient);
        setState(() {
          _ingredients.add(ingredient);
          recipeIngredientsController.clear();
          print(_ingredients);
        });
      }
    }

    Widget _showImage() {
      if (_imageUrl != null) {
        return Text("Image from url");
      }
      if (_imageFile != null) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(fit: StackFit.expand, children: [
            Container(
              child: Image.file(
                _imageFile,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.all(10),
                width: 35.0,
                height: 35.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.black54),
                child: IconButton(
                    padding: EdgeInsets.all(0.0),
                    icon: Image.asset(
                      "images/icon/close.png",
                      width: 15.0,
                      height: 15.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    }),
              ),
            ),
          ]),
        );
      }
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Icon(
                Icons.cloud_upload,
                color: Colors.white,
                size: 50.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Upload Picture",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    final pickedFile = await picker.getImage(
                      preferredCameraDevice: CameraDevice.rear,
                      imageQuality: 100,
                      source: ImageSource.camera,
                    );
                    setState(() {
                      if (pickedFile != null)
                        _imageFile = File(pickedFile.path);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    height: 40.0,
                    width: 100,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Camera",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final pickedFile = await picker.getImage(
                      source: ImageSource.gallery,
                    );
                    setState(() {
                      if (pickedFile != null)
                        _imageFile = File(pickedFile.path);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    height: 40.0,
                    width: 100,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Gallary",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // final auth = Provider.of<AuthBase>(context, listen: false);

    void addMethods(String methods) {
      if (methods.isNotEmpty) {
        print(methods);
        setState(() {
          _methods.add(methods);
          recipeMethodsController.clear();
          print(_methods);
        });
      }
    }

    return Container(
      color: Color(0xFF263238),
      child: ListView(
        // scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 8.0, left: 8, bottom: 0.0, right: 8.0),
            height: 200.0,
            width: MediaQuery.of(context).size.width,
            child: _showImage(),
          ),
          Divider(
            thickness: 0.0,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: recipeTitleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    alignLabelWithHint: true,
                    labelText: "Recipe Title",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),

                // Recipe description
                TextField(
                  controller: recipeDesController,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                    suffixText: "200 words",
                    suffixStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    alignLabelWithHint: true,
                    labelText: "Recipe Description",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),

                // video link
                TextField(
                  controller: recipeLinkController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    alignLabelWithHint: true,
                    labelText: "Youtube Video Link",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: recipeServesController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          alignLabelWithHint: true,
                          labelText: "Serves",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: recipeCookingTimeController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          alignLabelWithHint: true,
                          labelText: "Cook Time",
                          hintText: "2 hr 30 min",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Categories:",
                      style: style1,
                    ),
                  ),
                ),
                Container(
                  height: 50.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.length == 0
                        ? [
                            Center(
                              child: Text(
                                "No category selected",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            )
                          ]
                        : categories
                            .map(
                              (e) => Container(
                                margin: EdgeInsets.only(
                                    left: 5.0, right: 5.0, top: 10.0),
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0, left: 8.0),
                                        child: Text(
                                          e,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.all(0.0),
                                        icon: Image.asset(
                                            'images/icon/close.png',
                                            width: 15.0,
                                            height: 15.0,
                                            color: Colors.black),
                                        onPressed: () {
                                          categories.remove(e);
                                          setState(() {});
                                        })
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  height: 40.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        child: Text(
                          "Please add relevent categories",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCategories(func: function),
                          ),
                        ),
                        child: Container(
                          width: 80.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Center(
                              child: Text(
                            "Add",
                            style: style1,
                          )),
                        ),
                      )
                    ],
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: _ingredients.length != 0
                        ? Text("Ingredients:",
                            style: TextStyle(fontSize: 16, color: Colors.white))
                        : Text(
                            "No Ingredients Added",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    // onReorder: (oldIndex, newIndex) {
                    //   setState(() {
                    //     // _updateMyItems(oldIndex,newIndex)
                    //     _ingredients[oldIndex] = _ingredients[newIndex];
                    //   });
                    // },
                    children: _ingredients.length != null
                        ? _ingredients
                            .map(
                              (e) => ListTile(
                                key: ValueKey(e),
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _ingredients
                                          .removeAt(_ingredients.indexOf(e));
                                      setState(() {});
                                    }),
                                title: Text(
                                  "${_ingredients.indexOf(e) + 1}. " + e,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList()
                        : Container(),
                  ),
                ),

                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        controller: recipeIngredientsController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          alignLabelWithHint: true,
                          labelText: "Add Ingredients",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onChanged: (email) {},
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        addIngredients(recipeIngredientsController.text);
                      },
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(
                            child: Text(
                          "Add",
                          style: style1,
                        )),
                      ),
                    )
                  ],
                ),
                Container(
                  child: Column(
                    children: _methods.length != null
                        ? _methods
                            .map(
                              (e) => ListTile(
                                trailing: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _methods.removeAt(_methods.indexOf(e));
                                      setState(() {});
                                    }),
                                title: Text(
                                  "${_methods.indexOf(e) + 1}. " + e,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList()
                        : Container(),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        controller: recipeMethodsController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                          ),
                          alignLabelWithHint: true,
                          labelText: "Add Methods",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onChanged: (email) {},
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () => addMethods(recipeMethodsController.text),
                      child: Container(
                        width: 80.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Center(
                            child: Text(
                          "Add",
                          style: style1,
                        )),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          !isLoading
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.cancel),
                      iconSize: 50.0,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        isValid();
                      },
                      icon: Icon(Icons.check_circle),
                      iconSize: 50.0,
                      color: Colors.green,
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  TextStyle style1 = TextStyle(color: Colors.white);
}
