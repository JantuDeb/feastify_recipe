import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe/screens/add_recipe.dart';
import 'package:recipe/screens/drawer_list.dart';
import 'package:recipe/screens/home_screen.dart';
import 'package:recipe/screens/profile.dart';
import 'package:recipe/screens/saved_recipe_list.dart';
import 'package:recipe/screens/search_recipe.dart';
import 'package:recipe/screens/shopping_list.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';

class HomePage extends StatelessWidget {
  // Future<void> _signOut(BuildContext context) async {
  //   try {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     await auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future<void> _confirmSignOut(BuildContext context) async {
  //   final didRequestSignOut = await PlatformAlertDialog(
  //     title: 'Logout',
  //     content: 'Are you sure that you want to logout?',
  //     cancelActionText: 'Cancel',
  //     defaultActionText: 'Logout',
  //   ).show(context);
  //   if (didRequestSignOut == true) {
  //     _signOut(context);
  //   }
  // }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    PageController _pageController = PageController();
    Color colorWhite = Colors.white;

    List<Widget> _screens = [
      Home(),
      ShoppingList(),
      AddRecipe(),
      MyProfile(),
      SavedRecipeList()
    ];
    void _onPageChanged(int index) {
      _selectedIndex = index;
    }

    void onItemTapped(int selectedItem) {
      _pageController.jumpToPage(selectedItem);
    }

    Future<bool> _onWillPop() {
      if (_selectedIndex == 0) {
        return Future.value(true);
      } else {
        _selectedIndex = _selectedIndex - 1;
        _pageController.jumpToPage(_selectedIndex);
      }
      // _navigate(0);
      return Future.value(false);
    }

    // int _currentIndex;
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        drawer: Drawer(
          child: DrawerList(context),
        ),
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.search,
                color: colorWhite,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SearchRecipe(
                            database: database,
                            user: user,
                          ))),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 100,
            currentIndex: _selectedIndex,
            // border: Border(
            //     top: BorderSide(
            //         color: Color(0xFF263238),
            //         width: 0.0,
            //         style: BorderStyle.solid)),
            // unselectedIconTheme: IconThemeData(color: Colors.white, size: 20.0),
            // selectedIconTheme: IconThemeData(color: Colors.orange, size: 30.0),
            backgroundColor: Color(0xFF192024),
            type: BottomNavigationBarType.fixed,
            onTap: onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'images/icon/home.png',
                  width: 25.0,
                  height: 25.0,
                  // color: _onPageChanged == 0 ? Colors.amber : null,
                ),
                title: Text(
                  "dfgdh",
                  style: TextStyle(
                    fontSize: 1,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icon/basket.png',
                    width: 25.0, height: 25.0),
                title: Text(
                  "",
                  style: TextStyle(
                    fontSize: 1,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                // icon:SvgPicture.asseticon
                icon: Image(
                  width: 60.0,
                  height: 60.0,
                  image: AssetImage('images/icon/add-recipe.png'),
                ),
                title: Text(
                  "",
                  style: TextStyle(
                    fontSize: 1,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icon/user.png',
                    width: 25.0, height: 25.0),
                title: Text(
                  "",
                  style: TextStyle(
                    fontSize: 1,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Image.asset('images/icon/favorite.png',
                    width: 25.0, height: 25.0),
                title: Text(
                  "",
                  style: TextStyle(
                    fontSize: 1,
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
