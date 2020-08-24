import 'package:flutter/material.dart';
import 'package:recipe/common_widgets/saved_recipe_model.dart';
import 'package:recipe/screens/saved_recipe.dart';

class SavedRecipeList extends StatefulWidget {
  final List<SavedRecipeModel> product;
  SavedRecipeList({this.product});
  @override
  _SavedRecipeListState createState() => _SavedRecipeListState();
}

class _SavedRecipeListState extends State<SavedRecipeList> {
  TextStyle style1 = TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
      fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF263238),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: widget.product.map((SavedRecipeModel product) {
                return SavedRecipe(product);
              }).toList(),
            ),
          ),
          Container(
            height: 100.0,
            margin: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
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
        ],
      ),
    );
  }
}
