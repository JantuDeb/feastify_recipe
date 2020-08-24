// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:reorderables/reorderables.dart';

// class HomeTopTabs extends StatefulWidget {
//   _HomeTopTabsState createState() => _HomeTopTabsState();
// }

// class _HomeTopTabsState extends State<HomeTopTabs>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;
//   List<Tab> tabs = [];
//   int tabCount = 0;
//   // List<String> str = ["a", "b", "c"];
//   final CollectionReference categoryCollection =
//       Firestore.instance.collection('categories');

//   @override
//   void initState() {
//     super.initState();

//     _getCategoryTabs();

//     // print(tabs.length);
//     // print(tabCount);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleTabSelection() {
//     setState(() {});
//   }

//   Future<void> _getCategoryTabs() async {
//     await categoryCollection.getDocuments().then((QuerySnapshot snapshot) {
//       if (snapshot.documents.isNotEmpty) {
//         List<Tab> _tabs = [];
//         for (int i = 0; i < snapshot.documents.length; i++) {
//           DocumentSnapshot snap = snapshot.documents[i];
//           // tabCount++;
//           _tabs.add(
//             Tab(
//               child: Text(
//                 snap.documentID,
//                 // style: TextStyle(color: Colors.white),
//               ),
//             ),
//           );
//         }
//         setState(() {
//           print(_tabs.length.toString() + "inner");
//           tabCount = _tabs.length;
//           tabs = _tabs;
//           _tabController = TabController(vsync: this, length: tabCount);
//           _tabController.addListener(_handleTabSelection);
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: tabCount,
//       child: Scaffold(
//         backgroundColor: Color(0xFF263238),
//         appBar: AppBar(
//             leading: null,
//             elevation: 0.0,
//             // titleSpacing: 0.0,
//             backgroundColor: Color(0xFF263238),
//             title: Text("Top Categories"),
//             bottom: TabBar(
//                 controller: _tabController,
//                 isScrollable: true,
//                 indicatorWeight: 0.1,
//                 indicatorPadding: EdgeInsets.all(0.0),
//                 indicatorColor: Colors.transparent,
//                 unselectedLabelColor: Colors.white,
//                 labelColor: Colors.orange,
//                 tabs: tabs
//                 /*
//               [
//                 Tab(
//                   child: Text(
//                     'Indian Recipe',
//                   ),
//                 ),
//                 Tab(
//                   child: Text(
//                     'Thai Recipe',
//                   ),
//                 ),
//                 Tab(
//                   child: Text(
//                     'Indian Recipe',
//                   ),
//                 ),
//                 // Tab(
//                 //   child: Text(
//                 //     'Indian Recipe',
//                 //   ),
//                 // ),
//                 // Tab(
//                 //   child: Text(
//                 //     'Indian Recipe',
//                 //   ),
//                 // ),
//               ],*/
//                 )),
//         body: TabBarView(
//           controller: _tabController,
//           children: <Widget>[
//             Container(
//               height: 150.0,
//               child: CustomList(),
//             ),
//             Container(
//               height: 150.0,
//               child: CustomList(),
//             ),
//             Container(
//               height: 150.0,
//               child: CustomList(),
//             ),
//             // Container(
//             //   height: 150.0,
//             //   child: CustomList(),
//             // ),
//             // Container(
//             //   height: 150.0,
//             //   child: CustomList(),
//             // ),
//             // Container(
//             //   height: 150.0,
//             //   child: CustomList(),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomList extends StatelessWidget {
//   const CustomList({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imgList = [
//       'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//       'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//       'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//       'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//       'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//       'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
//     ];

//     final List<Widget> imageSliders = imgList
//         .map((item) => Container(
//               child: Container(
//                 width: 200,
//                 margin: EdgeInsets.all(10.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                   child: Stack(
//                     children: <Widget>[
//                       Image.network(item, fit: BoxFit.cover, width: 1000.0),
//                       Positioned(
//                         bottom: 0.0,
//                         left: 0.0,
//                         right: 0.0,
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 Color.fromARGB(200, 0, 0, 0),
//                                 Color.fromARGB(0, 0, 0, 0)
//                               ],
//                               begin: Alignment.bottomCenter,
//                               end: Alignment.topCenter,
//                             ),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 20.0),
//                           child: Text(
//                             'Recipe By Priyanka',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15.0,
//                               fontWeight: FontWeight.normal,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ))
//         .toList();

//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: imageSliders,
//     );
//   }
// // }
// // StreamBuilder<QuerySnapshot>(
// //                     stream:
// //                         Firestore.instance.collection("categories").snapshots(),
// //                     builder: (context, snapshot) {
// //                       if (!snapshot.hasData) {
// //                         return Container(
// //                           child: const Text("Loading....."),
// //                           height: 20.0,
// //                         );
// //                       } else {
// //                         List<DropdownMenuItem> currencyItems = [];
// //                         for (int i = 0;
// //                             i < snapshot.data.documents.length;
// //                             i++) {
// //                           DocumentSnapshot snap = snapshot.data.documents[i];
// //                           currencyItems.add(
// //                             DropdownMenuItem(
// //                               child: Text(
// //                                 snap.documentID,
// //                                 style: TextStyle(color: Colors.white),
// //                               ),
// //                               value: "${snap.documentID}",
// //                             ),
// //                           );
// //                         }
// //                         return Container(
// //                           child: DropdownButton(
// //                             // isDense: true,
// //                             isExpanded: true,
// //                             dropdownColor: Color(0xFF263235),
// //                             hint: Text(
// //                               'Please Choose a Category',
// //                               style: TextStyle(color: Colors.white),
// //                             ), // Not necessary for Option 1
// //                             value: _selectedCategory,
// //                             onChanged: (newValue) {
// //                               setState(() {
// //                                 _selectedCategory = newValue;
// //                                 // _showcategories.add(_selectedCategory);
// //                               });
// //                               print(_selectedCategory);
// //                             },
// //                             items: currencyItems,
// //                           ),
// //                         );
// //                       }
// //                     })
// }
// class _ColumnExample1State extends State<ColumnExample1> {
//   List<Widget> _rows;

//   @override
//   void initState() {
//     super.initState();
//     _rows = List<Widget>.generate(50,
//         (int index) => Text('This is row $index', key: ValueKey(index), textScaleFactor: 1.5)
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     return ReorderableColumn(

//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: _rows,
//       onReorder: _onReorder,
//     );
//   }
// }
