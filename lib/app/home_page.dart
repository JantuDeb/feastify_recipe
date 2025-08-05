import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:recipe/screens/add_recipe.dart';
import 'package:recipe/screens/drawer_list.dart';
import 'package:recipe/screens/home_screen.dart';
import 'package:recipe/screens/profile.dart';
import 'package:recipe/screens/saved_recipe_list.dart';
import 'package:recipe/screens/search_recipe.dart';
import 'package:recipe/screens/shopping_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/services/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedItem) {
    _pageController.jumpToPage(selectedItem);
  }

  Future<bool> _onWillPop() {
    if (_selectedIndex == 0) {
      return Future.value(true);
    } else {
      setState(() {
        _selectedIndex = _selectedIndex - 1;
      });
      _pageController.jumpToPage(_selectedIndex);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    final colorWhite = Colors.white;

    final _screens = [
      Home(),
      ShoppingList(),
      AddRecipe(),
      MyProfile(),
      SavedRecipeList()
    ];

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _onWillPop();
      },
      child: Scaffold(
        drawer: Drawer(
          child: DrawerList(context),
        ),
        appBar: AppBar(
          backgroundColor: Colors.orange[600],
          actions: <Widget>[
            TextButton(
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
                  ),
                ),
              ),
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
          backgroundColor: Color(0xFF192024),
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/icon/home.png',
                width: 25.0,
                height: 25.0,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/icon/basket.png',
                  width: 25.0, height: 25.0),
              label: "Shopping",
            ),
            BottomNavigationBarItem(
              icon: Image(
                width: 60.0,
                height: 60.0,
                image: AssetImage('images/icon/add-recipe.png'),
              ),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/icon/user.png',
                  width: 25.0, height: 25.0),
              label: "Profile",
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/icon/favorite.png',
                  width: 25.0, height: 25.0),
              label: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
