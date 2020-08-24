import 'package:flutter/material.dart';
import 'package:recipe/common_widgets/saved_recipe_model.dart';

class SavedRecipe extends StatefulWidget {
  final SavedRecipeModel product;
  SavedRecipe(SavedRecipeModel product)
      : product = product,
        super(key: new ObjectKey(product));
  @override
  SavedRecipeState createState() {
    return SavedRecipeState(product);
  }
}

class SavedRecipeState extends State<SavedRecipe> {
  final SavedRecipeModel product;
  SavedRecipeState(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.all(0.0),
        onTap: null,
        leading: Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.orange,
            value: product.isCheck,
            onChanged: (bool value) {
              setState(() {
                product.isCheck = value;
              });
            }),
        title: Row(
          children: <Widget>[
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
                  image: AssetImage(
                    product.avatarImage,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.36,
              margin: EdgeInsets.only(right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
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
                    product.title,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
