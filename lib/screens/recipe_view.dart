import 'package:flutter/material.dart';

class RecipeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    TextStyle style1 = TextStyle(color: Colors.white, fontSize: 18.0);
    TextStyle style2 = TextStyle(color: Colors.white, fontSize: 16.0);
    final List<String> items = [
      '300 gm Kaju',
      '1/2 tablespoon white sugar',
      '300 gm Kaju',
      '300 gm Kaju',
      '1/2 tablespoon white sugar'
    ];
    final List<String> methods = [
      'Reducing the number of considered missed Gc histog',
      'Reducing the number of considered missed Gc histog',
      'Reducing the number of considered missed Gc histog',
      'Reducing the number of considered missed Gc histog',
      'Reducing the number of considered missed Gc histog',
      'Reducing the number of considered missed Gc histogeducing the number of considered missed Gc histog'
    ];

    return Material(
      child: Scaffold(
        body: Container(
          color: Color(0xFF263238),
          child: ListView(
            children: <Widget>[
              Container(
                height: 200.0,
                width: screenWidth,
                child: Stack(fit: StackFit.expand, children: <Widget>[
                  Image(
                    image: AssetImage('images/Searchpage-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: IconButton(
                        iconSize: 50.0,
                        icon: Image(
                          image: AssetImage('images/youtube.png'),
                        ),
                        onPressed: null),
                  ),
                ]),
              ),
              Container(
                height: 70.0,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                        style: BorderStyle.solid)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              "2523",
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                icon: Icon(Icons.thumb_up, color: Colors.white),
                                onPressed: null),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              "2523",
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                icon: Icon(Icons.remove_red_eye,
                                    color: Colors.white),
                                onPressed: null),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // width: screenWidth / 3.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                              style: BorderStyle.solid),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              "2523",
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                                icon: Icon(Icons.favorite, color: Colors.white),
                                onPressed: null),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 100.0,
                color: Color(0xFF262626),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      width: 60.0,
                      height: 60.0,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            "images/profile_image.jpg",
                            fit: BoxFit.cover,
                            width: 90.0,
                            height: 90.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Priyanka Chattarjee",
                            style: style1,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            "India",
                            style: style2,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 30.0,
                          width: 80.0,
                          margin: EdgeInsets.only(right: 30.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              border:
                                  Border.all(width: 1.0, color: Colors.white)),
                          child: Center(
                            child: Text(
                              "Follow",
                              style: style1,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 8.0, top: 20.0, right: 30.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Chicken Curry",
                      style: style1,
                    ),
                    Spacer(),
                    IconButton(
                        iconSize: 20.0,
                        icon: Image(
                          image: AssetImage('images/share.png'),
                          color: Colors.white,
                          width: 20.0,
                        ),
                        onPressed: null)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "Blue is used as the primary color for areas of the app that relate to the user’s personal account, such as selected courses.",
                  style: style2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(20.0),
                      elevation: 5.0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                        child:
                            Text("Category", style: TextStyle(fontSize: 18.0)),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Serves  2", style: style2),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 1.0,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              "Cooking Time 1hr 30 min",
                              style: style2,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ingredients",
                        style: style1,
                      ),
                    ),
                    Column(
                      children: items
                          .map((item) => ListTile(
                                trailing: Icon(
                                  Icons.add_circle,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  item,
                                  style: style2,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              Divider(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Method",
                        style: style1,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: methods
                          .map((item) => ListTile(
                                // leading: Image.asset(
                                //   'images/dot.png',
                                //   width: 10.0,
                                //   height: 10.0,
                                // ),

                                contentPadding:
                                    EdgeInsets.only(left: 15.0, right: 15.0),
                                title: Text(
                                  item,
                                  style: style2,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
    //Scafold
  }
}

/*
Scaffold(
      backgroundColor: Color(0xFF263238),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Icon(
              Icons.search,
              size: 30.0,
            ),
          ),
        ],
      ),
      drawer: Drawer(),
      body:
*/
