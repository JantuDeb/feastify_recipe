import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe/models/followers.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';
import 'package:recipe/services/firebase_transection.dart';

class Following extends StatefulWidget {
  Following({Key key, this.database, this.currentIndex, this.user})
      : super(key: key);

  final Database database;
  final User user;
  final int currentIndex;

  @override
  _FollowingState createState() => _FollowingState(currentIndex);
}

class _FollowingState extends State<Following>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final int currentIndex;
  bool isLoading = false;
  List<Followers> followings;
  List<Followers> followers;
  _FollowingState(this.currentIndex);
  // List<Tab> tabs = [];
  // int tabCount = 0;
  // List<String> str = ["a", "b", "c"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    _tabController.index = currentIndex;
    getFollowingsData();
    getFollowers();
    // print(tabs.length);
    // print(tabCount);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.followers.length);
    return Material(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange[600],
              child: Image.asset(
                'images/icon/close.png',
                width: 25.0,
                height: 25.0,
              ),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Color(0xFF263238),
          appBar: AppBar(
              leading: Text(""),
              toolbarHeight: 50.0,
              elevation: 0.0,
              // titleSpacing: 0.0,
              backgroundColor: Colors.orange[600],
              // title: Text("Top Categories"),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicatorWeight: 3.5,
                indicatorPadding: EdgeInsets.all(0.0),
                indicatorColor: Colors.white.withAlpha(150),
                unselectedLabelColor: Color(0xFF263238),
                labelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'Followers',
                  ),
                  Tab(
                    text: 'Following',
                  ),
                ],
              )),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                  // chheight: 150.0,
                  child: followers == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildFollowersList(currentIndex)),
              Container(
                child: followings == null || isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : _buildFollowing(currentIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFollowingsData() async {
    try {
      var snapshots = await widget.database.followingCount();
      followings = snapshots
          .map((snapshot) =>
              Followers.fromFollowersMap(snapshot.data, snapshot.documentID))
          .toList();
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  getFollowers() async {
    try {
      var snapshots = await widget.database.followersCount();
      followers = snapshots
          .map((snapshot) =>
              Followers.fromFollowersMap(snapshot.data, snapshot.documentID))
          .toList();
      setState(() {});
    } on Exception catch (e) {
      print(e);
    }
  }

  _buildFollowing(int currentIndex) {
    return ListView.builder(
      itemCount: followings.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              // title: Text("${widget.snapshots[index].['']}),
              leading: Container(
                // margin: EdgeInsets.only(left: 30.0, right: 10.0),
                height: 50.0,
                width: 50.0, //MediaQuery.of(context).size.width * 0.2,/*/
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(50.0)),
                child: CircleAvatar(
                  child: ClipOval(
                    child: followings[index].photoUrl == null
                        ? Image.asset(
                            "images/profile_image.jpg",
                            fit: BoxFit.cover,
                            width: 90.0,
                            height: 90.0,
                          )
                        : Image(
                            image: CachedNetworkImageProvider(
                                followings[index].photoUrl),
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              title: Text(
                '${followings[index].userName}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  widget.database
                      .unFollowUser(followingUserId: followings[index].id);
                  FirebaseTransection()
                      .updateUnFollow(widget.user.uid, followings[index].id);

                  getFollowingsData();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white, width: 0.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: Text(
                      "Unfollow",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  _buildFollowersList(int currentIndex) {
    return ListView.builder(
      itemCount: followers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            // title: Text("${widget.snapshots[index].['']}),
            leading: Container(
              // margin: EdgeInsets.only(left: 30.0, right: 10.0),
              height: 50.0,
              width: 50.0, //MediaQuery.of(context).size.width * 0.2,/*/
              // decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(50.0)),
              child: CircleAvatar(
                child: ClipOval(
                  child: followers[index].photoUrl == null
                      ? Image.asset(
                          "images/profile_image.jpg",
                          fit: BoxFit.cover,
                          width: 90.0,
                          height: 90.0,
                        )
                      : Image(
                          image: CachedNetworkImageProvider(
                              followers[index].photoUrl),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            title: Text(
              '${followers[index].userName}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
