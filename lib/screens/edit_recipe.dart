import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/add_categories.dart';
import 'package:recipe/services/auth.dart';
// import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
// import 'package:reorderables/reorderables.dart';

class EditRecipe extends StatefulWidget {
  const EditRecipe(
      {Key key, this.recipe, this.mContext, this.database, this.user})
      : super(key: key);
  final Recipe recipe;
  final BuildContext mContext;
  final Database database;
  final User user;

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  List<String> _ingredients = [];
  List<String> _methods = [];
  Set<String> categories = {};
  File _imageFile;
  String _imageUrl;
  final picker = ImagePicker();

  //Controllers
  final recipeIngredientsController = TextEditingController();
  final recipeMethodsController = TextEditingController();
  var recipeTitleController = TextEditingController();
  var recipeDesController = TextEditingController();
  var recipeLinkController = TextEditingController();
  var recipeServesController = TextEditingController();
  var recipeCookingTimeController = TextEditingController();

  @override
  void initState() {
    print(categories.toString() + "___");
    _ingredients = widget.recipe.ingredients;
    _methods = widget.recipe.methods;
    categories = widget.recipe.categories.toSet();
    _imageUrl = widget.recipe.photoUrl;
    recipeCookingTimeController =
        TextEditingController(text: widget.recipe.cookingTime);
    recipeTitleController =
        TextEditingController(text: widget.recipe.recipeTitle);
    recipeDesController =
        TextEditingController(text: widget.recipe.recipeDescription);
    recipeLinkController =
        TextEditingController(text: widget.recipe.recipeLink);
    recipeServesController = TextEditingController(text: widget.recipe.serves);
    super.initState();
  }

  @override
  void dispose() {
    // recipeCookingTimeController.dispose();
    // recipeDesController.dispose();
    // recipeServesController.dispose();
    // recipeLinkController.dispose();
    // recipeTitleController.dispose();
    // recipeServesController.dispose();
    super.dispose();
  }

  function(value) {
    categories = value;
    setState(() {});
  }

  Future<void> _submit() async {
    // final auth = Provider.of<AuthBase>(context, listen: false);
    // final user = Provider.of<User>(widget.mContext, listen: false);
    // final id = widget.recipe?.id ?? documentIdFromDTN();
    // final database = Provider.of<Database>(widget.mContext, listen: false);
    final recipe = Recipe(
        id: widget.recipe.id,
        photoUrl: _imageUrl,
        serves: recipeServesController.text,
        cookingTime: recipeCookingTimeController.text,
        recipeLink: recipeLinkController.text.toString(),
        recipeTitle: recipeTitleController.text,
        recipeDescription: recipeDesController.text,
        categories: categories.toList(),
        methods: _methods,
        ingredients: _ingredients,
        recipeId: widget.user.uid,
        createdBy: widget.user.uid,
        createdAt: Timestamp.now());
    await widget.database
        .createRecipe(recipe)
        .then((value) => Navigator.pop(context));
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

  @override
  Widget build(BuildContext context) {
    // List<String> _category = ['Please Choose a Category', 'A', 'B', 'C', 'D'];
    // List<String> _showcategories = [];

    void addIngredients(String ingredient) {
      if (ingredient.isNotEmpty) {
        print(ingredient);
        setState(() {
          _ingredients.add(ingredient);
          recipeIngredientsController.clear();
          print(_ingredients);
        });
        // recipeIngredientsController.clear();
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
        // recipeIngredientsController.clear();
      }
    }

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Recipe"),
          backgroundColor: Colors.orange[600],
        ),
        body: Container(
          color: Color(0xFF263238),
          child: ListView(
            // scrollDirection: Axis.vertical,
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 8.0, left: 8, bottom: 0.0, right: 8.0),
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
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
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
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
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
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.0),
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
                                                top: 8.0,
                                                bottom: 8.0,
                                                left: 8.0),
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  color: Colors.black),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white))
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
                                          _ingredients.removeAt(
                                              _ingredients.indexOf(e));
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
                                          _methods
                                              .removeAt(_methods.indexOf(e));
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
              Row(
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
                      _submit();
                    },
                    icon: Icon(Icons.check_circle),
                    iconSize: 50.0,
                    color: Colors.green,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  TextStyle style1 = TextStyle(color: Colors.white);
}
