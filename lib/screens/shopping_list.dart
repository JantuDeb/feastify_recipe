import 'package:flutter/material.dart';

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key}) : super(key: key);

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  TextStyle style1 = TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextStyle style2 = TextStyle(
      fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold);
  TextEditingController listController = TextEditingController();
  Map<String, bool> values = {
    '250 gm Chicken': true,
    '500 gm Milk': false,
    '100 gm curd': true,
    '1/2 inch ginger': false,
    'Black chaat masala': true,
    'A few pomegranate seeds': false,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF263238),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  // color: Color(0xFF263238),
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    "Shopping list",
                    style: style1,
                  ),
                ),
                Column(
                  children: values.keys.map((String key) {
                    return CheckboxListTile(
                      checkColor: Colors.orange,
                      activeColor: Colors.white,
                      title: Text(
                        key,
                        style: style2,
                      ),
                      value: values[key],
                      onChanged: (bool value) {
                        setState(() {
                          values[key] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: listController,
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
                            labelText: "Items",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          onChanged: (email) {},
                        ),
                      ),
                      Spacer(),
                      RaisedButton(
                        onPressed: () {
                          if (listController.text.isNotEmpty) {
                            values.addAll({listController.text: false});
                            setState(() {
                              print(values);
                              listController.clear();
                            });
                          }
                        },
                        child: Text("Add"),
                      )
                    ],
                  ),
                ),
              ],
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
                    values.removeWhere(
                        (key, value) => value.toString().startsWith('t'));
                    setState(() {});
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
