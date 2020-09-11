import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/screens/add_categories.dart';
import 'package:recipe/services/auth.dart';
// import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
import 'package:reorderables/reorderables.dart';
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
  var recipeCookingTimeController1 = TextEditingController();

  @override
  void initState() {
    print(categories.toString() + "___");
    _ingredients = widget.recipe.ingredients;
    _methods = widget.recipe.methods;
    categories = widget.recipe.categories.toSet();
    _imageUrl = widget.recipe.photoUrl;
    // recipeCookingTimeController =
    //     TextEditingController(text: widget.recipe.cookingTime);
    //         recipeCookingTimeController1 =
    //     TextEditingController(text: widget.recipe.cookingTime);
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
    String ctime = recipeCookingTimeController.text != null
        ? recipeCookingTimeController.text +
            " hr " +
            recipeCookingTimeController1.text +
            " min"
        : recipeCookingTimeController1.text;
    // final auth = Provider.of<AuthBase>(context, listen: false);
    // final user = Provider.of<User>(widget.mContext, listen: false);
    // final id = widget.recipe?.id ?? documentIdFromDTN();
    // final database = Provider.of<Database>(widget.mContext, listen: false);
    final recipe = Recipe(
        id: widget.recipe.id,
        photoUrl: _imageUrl,
        serves: recipeServesController.text,
        cookingTime: ctime,
        recipeLink: recipeLinkController.text.toString(),
        recipeTitle: recipeTitleController.text,
        recipeDescription: recipeDesController.text,
        categories: categories.toList(),
        methods: _methods,
        ingredients: _ingredients,
        recipeId: widget.user.uid,
        createdBy: widget.recipe.createdBy,
        likeCount: widget.recipe.likeCount,
        likes: widget.recipe.likes,
        searchQuery: widget.recipe.searchQuery,
        viewCount: widget.recipe.viewCount,
        createdAt: Timestamp.now());
    await widget.database
        .updateRecipe(recipe)
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
      if (_imageFile == null && _imageUrl == null) {
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
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
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
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.black),
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
      } else if (_imageFile != null) {
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
        width: MediaQuery.of(context).size.width,
        child: Stack(fit: StackFit.expand, children: [
          Container(
            child: Image.network(
              _imageUrl,
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
                    'images/icon/close.png',
                    width: 15.0,
                    height: 15.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _imageUrl = null;
                    });
                  }),
            ),
          ),
        ]),
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

    // Color tColor = Colors.blue;
    List<Widget> _buildMethods() {
      return _methods
          .map<Widget>(
            (e) => Container(
              // margin: EdgeInsets.symmetric(horizontal: 5.0),
              color: Color(0xFF263238),
              key: ValueKey(e),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Step ${_methods.indexOf(e) + 1}: " + e,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.reorder,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // _methods.removeAt(_methods.indexOf(e));
                          // setState(() {});
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _methods.removeAt(_methods.indexOf(e));
                          setState(() {});
                        })
                  ],
                ),
              ),
            ),
          )
          .toList();
    }

    List<Widget> _buildIngred() {
      return _ingredients
          .map<Widget>(
            (e) => Container(
              // margin: EdgeInsets.symmetric(horizontal: 5.0),
              color: Color(0xFF263238),
              key: ValueKey(e),
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_ingredients.indexOf(e) + 1}: " + e,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.reorder,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // _methods.removeAt(_methods.indexOf(e));
                          // setState(() {});
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _ingredients.removeAt(_ingredients.indexOf(e));
                          setState(() {});
                        })
                  ],
                ),
              ),
            ),
          )
          .toList();
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
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  // style: TextStyle(color: Colors.white.withAlpha(200,),fontSize: 12.0),
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
              ),

              // Recipe description
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: recipeDesController,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  minLines: 1,
                  decoration: InputDecoration(
                    // helperStyle: TextStyle(color: Colors.black),
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
              ),

              // video link
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
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
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: recipeCookingTimeController,
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
                          labelText: "Cook Time",
                          hintText: "hours",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: recipeCookingTimeController1,
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
                          labelText: "",
                          hintText: "min",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Categories:",
                      style: style1,
                    ),
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
                                  left: 10.0, right: 10.0, top: 10.0),
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
                                      icon: Image.asset('images/icon/close.png',
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  // margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      // margin: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextField(
                        style: TextStyle(color: Colors.white),
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
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
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
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    // margin: EdgeInsets.symmetric(vertical: 5.0),
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
              ),
              Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 5.0, right: 5),
                // height: 85.0 * _methods.length,
                child: ReorderableColumn(
                  children: _buildIngred(),
                  scrollController: ScrollController(initialScrollOffset: 50),
                  // needsLongPressDraggable: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      // tColor = Colors.black;
                      // if (newIndex >= _methods.length) {
                      //   newIndex = _methods.length;
                      // }
                      final String temp = _ingredients[oldIndex];
                      _ingredients.removeAt(oldIndex);
                      _ingredients.insert(newIndex, temp);
                    });
                  },
                ),
              ),

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
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
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
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
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: _methods.length != 0
                        ? Text("Methods:",
                            style: TextStyle(fontSize: 16, color: Colors.white))
                        : Text(
                            "No Methods Added",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                // height: 85.0 * _methods.length,
                child: ReorderableColumn(
                  children: _buildMethods(),
                  scrollController: ScrollController(initialScrollOffset: 50),
                  // needsLongPressDraggable: false,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      // tColor = Colors.black;
                      // if (newIndex > oldIndex) {
                      //   newIndex = newIndex - 1;
                      // }
                      final String temp = _methods[oldIndex];
                      _methods.removeAt(oldIndex);
                      _methods.insert(newIndex, temp);
                    });
                  },
                ),
              ),

              Center(
                child: IconButton(
                  onPressed: () {
                    _submit();
                  },
                  icon: Icon(Icons.check_circle),
                  iconSize: 50.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle style1 = TextStyle(color: Colors.white);
}
