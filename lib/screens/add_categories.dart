import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  final func;
  const AddCategories({Key key, this.func});
  @override
  _AddCategoriesState createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final CollectionReference categoryCollection =
      Firestore.instance.collection('categories');
  bool isSelected = false;
  Set<String> selectedCategory = {};
  Map<String, bool> values = {};
  Future<void> _getCategories() async {
    await categoryCollection.getDocuments().then((QuerySnapshot snapshot) {
      if (snapshot.documents.isNotEmpty) {
        for (int i = 0; i < snapshot.documents.length; i++) {
          DocumentSnapshot snap = snapshot.documents[i];
          values.addAll({snap.documentID.toString(): false});
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Choose Categories'),
      ),
      backgroundColor: Color(0xFF263238),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: values.length == 0
                    ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(
                        child: ListView(
                          children: values.keys.map((String key) {
                            return CheckboxListTile(
                              checkColor: Colors.orange,
                              activeColor: Colors.white,
                              title: Text(
                                key,
                                style: TextStyle(color: Colors.white),
                                // style: style2,
                              ),
                              value: values[key],
                              onChanged: (bool value) {
                                setState(() {
                                  values[key] = value;
                                });
                                print(key);
                                print(selectedCategory);
                              },
                            );
                          }).toList(),
                        ),
                      ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                height: 60.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Colors.redAccent,
                        onPressed: () {
                          selectedCategory.clear();

                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Colors.green,
                        child: Text("Add"),
                        onPressed: () {
                          values.forEach((key, value) {
                            if (value.toString().startsWith("t")) {
                              selectedCategory.add(key);
                              // setState(() {
                              // });
                            }
                          });
                          widget.func(selectedCategory);
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
