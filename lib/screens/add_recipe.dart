import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/models/user.dart';
import 'package:recipe/screens/add_categories.dart';
import 'package:recipe/services/auth.dart';

import 'package:recipe/services/database.dart';
import 'package:reorderables/reorderables.dart';
// import 'package:reorderables/reorderables.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key key, this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe>
    with AutomaticKeepAliveClientMixin {
  List<String> _ingredients = [];
  List<String> _methods = [];
  Set<String> categories = {};
  File imageFile;
  // String imgUrl;

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
  UserData userData;

  @override
  void dispose() {
    recipeIngredientsController.dispose();
    super.dispose();
  }

  void getData() async {
    Database database = Provider.of<Database>(context, listen: false);
    UserData data = await database.getUserById();
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  function(value) {
    categories = value;
    setState(() {});
  }

  // Future<String> uploadImageToStorage(File imageFile) async {
  //   StorageReference _storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('recipeImage/${DateTime.now().millisecondsSinceEpoch}');
  //   StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
  //   var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
  //   return url;
  // }

  Future<void> _submit({@required String photoUrl}) async {
    print(recipeTitleController.text.length);
    setSearchParam(recipeTitleController.text);
    // final auth = Provider.of<AuthBase>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    final id = widget.recipe?.id ?? documentIdFromDTN();
    final database = Provider.of<Database>(context, listen: false);

    final recipe = Recipe(
        id: id,
        photoUrl: photoUrl,
        recipeTitle: recipeTitleController.text,
        createdBy: userData.userName,
        categories: categories.toList(),
        methods: _methods,
        ingredients: _ingredients,
        recipeId: user.uid,
        recipeDescription: recipeDesController.text,
        serves: recipeServesController.text,
        recipeLink: recipeLinkController.text,
        cookingTime: recipeCookingTimeController.text,
        searchQuery: searchList,
        likes: {},
        viewCount: 0,
        createdAt: Timestamp.now());
    database.createRecipe(recipe);
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
    imageFile = null;
    searchList.clear();
  }

  bool isValid() {
    if (_ingredients.length >= 1 &&
            _methods.length >= 1 &&
            categories.length >= 1 &&
            recipeTitleController.text.length >= 5 &&
            recipeDesController.text.length >= 10 &&
            recipeServesController.text.isNotEmpty &&
            recipeCookingTimeController.text.length >= 3
        // &&_imageUrl != null
        ) {
      // compressImage();
      return true;
    } else {
      return false;
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

  void handleSubmit() async {
    final database = Provider.of<Database>(context, listen: false);
    String url = await database.uploadImageToStorage(imageFile);
    _submit(photoUrl: url);
    _clearController();
    setState(() {
      // _clearController();
      isLoading = false;
      imageFile = null;
    });
  }
  // Future<void> compressImage() async {
  //   if (imageFile != null) {
  //     print('starting compression');
  //     final tempDir = await getTemporaryDirectory();
  //     final path = tempDir.path;
  //     int rand = Random().nextInt(10000);

  //     Im.Image image = Im.decodeImage((imageFile).readAsBytesSync());
  //     Im.copyResize(image, height: 675, width: 960);

  //     var _newImage = new File('$path/img_$rand.jpg')
  //       ..writeAsBytesSync(Im.encodeJpg(image, quality: 23));

  //     setState(() {
  //       imageFile = _newImage;
  //       isLoading = false;
  //       print('done');
  //     });
  //   } else {
  //     print("error ");
  //     isLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      if (imageFile != null) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(fit: StackFit.expand, children: [
            Container(
              child: Image.file(
                imageFile,
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
                        imageFile = null;
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
                        imageQuality: 50,
                        source: ImageSource.camera,
                        maxHeight: 960,
                        maxWidth: 675);
                    setState(() {
                      if (pickedFile != null) imageFile = File(pickedFile.path);
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
                        imageQuality: 50,
                        maxHeight: 960,
                        maxWidth: 675);
                    setState(() {
                      if (pickedFile != null) imageFile = File(pickedFile.path);
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
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
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
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
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
                          margin:
                              EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
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
          // Container(
          //   margin: EdgeInsets.only(top: 10.0),
          //   child: Column(
          //     // onReorder: (oldIndex, newIndex) {
          //     //   setState(() {
          //     //     // _updateMyItems(oldIndex,newIndex)
          //     //     _ingredients[oldIndex] = _ingredients[newIndex];
          //     //   });
          //     // },
          //     children: _ingredients.length != null
          //         ? _ingredients
          //             .map(
          //               (e) => ListTile(
          //                 key: ValueKey(e),
          //                 trailing: IconButton(
          //                     icon: Icon(
          //                       Icons.delete,
          //                       color: Colors.white,
          //                     ),
          //                     onPressed: () {
          //                       _ingredients
          //                           .removeAt(_ingredients.indexOf(e));
          //                       setState(() {});
          //                     }),
          //                 title: Text(
          //                   "${_ingredients.indexOf(e) + 1}. " + e,
          //                   style: TextStyle(color: Colors.white),
          //                 ),
          //               ),
          //             )
          //             .toList()
          //         : Container(),
          //   ),
          // ),

          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: recipeIngredientsController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
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
          Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: recipeMethodsController,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 0.0),
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
                        print(isLoading);
                        isValid() == true ? handleSubmit() : notValid();
                        // isValid();
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

  notValid() {
    setState(() {
      isLoading = false;
    });
    print("not Valid");
  }

  @override
  bool get wantKeepAlive => true;
}
