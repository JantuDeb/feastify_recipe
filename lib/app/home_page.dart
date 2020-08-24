import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe/common_widgets/saved_recipe_model.dart';
import 'package:recipe/screens/add_recipe.dart';
import 'package:recipe/screens/drawer_list.dart';
import 'package:recipe/screens/home_screen.dart';
import 'package:recipe/screens/profile.dart';
import 'package:recipe/screens/saved_recipe_list.dart';
import 'package:recipe/screens/search_recipe.dart';
import 'package:recipe/screens/shopping_list.dart';

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

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    Color colorWhite = Colors.white;
    int _selectedIndex = 0;
    List<Widget> _screens = [
      Home(),
      ShoppingList(),
      AddRecipe(),
      MyProfile(),
      SavedRecipeList(product: [
        SavedRecipeModel("Chicken Curry", "By Chef Priyanka",
            "images/Searchpage-image2.jpg", false),
        SavedRecipeModel("Black Current Pie", "By Chef Priyanka",
            "images/Searchpage-image3.jpg", false),
        SavedRecipeModel("Cocolate Truffle Ca...", "By Chef Priyanka",
            "images/Searchpage-image4.jpg", false),
        SavedRecipeModel("Chicken Curry", "By Chef Priyanka",
            "images/Searchpage-image5.jpg", false),
        SavedRecipeModel("Cocolate Truffle Ca...", "By Chef Priyanka",
            "images/Searchpage-image2.jpg", false),
      ])
    ];
    void _onPageChanged(int index) {
      _selectedIndex = index;
    }

    void onItemTapped(int selectedItem) {
      _pageController.jumpToPage(selectedItem);
    }

    // int _currentIndex;
    return Scaffold(
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
                context, MaterialPageRoute(builder: (_) => SearchRecipe())),
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
          currentIndex: _selectedIndex,
          unselectedIconTheme: IconThemeData(color: Colors.white, size: 20.0),
          selectedIconTheme: IconThemeData(color: Colors.orange, size: 30.0),
          backgroundColor: Color(0xFF333333),
          type: BottomNavigationBarType.fixed,
          onTap: onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'images/icon/home.png',
                width: 30.0,
                height: 30.0,
                // color: _selectedIndex == 0 ? Colors.amber : null,
              ),
              title: Text(
                "",
                style: TextStyle(
                  fontSize: 1,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/icon/basket.png',
                  width: 30.0, height: 30.0),
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
                width: 50.0,
                height: 50.0,
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
                  width: 30.0, height: 30.0),
              title: Text(
                "",
                style: TextStyle(
                  fontSize: 1,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/icon/favorite.png',
                  width: 30.0, height: 30.0),
              title: Text(
                "",
                style: TextStyle(
                  fontSize: 1,
                ),
              ),
            ),
          ]),
    );
  }
}
