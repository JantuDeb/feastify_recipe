import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe/screens/add_categories.dart';
import 'package:recipe/services/auth.dart';
import 'package:recipe/services/database.dart';

import 'home_page.dart';
import 'sign_in/sign_in_page.dart';

class LandingPage extends StatelessWidget {
  final CollectionReference userRef = Firestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    Future<void> getUserID(User user) async {
      final DocumentSnapshot doc = await userRef.document(user.uid).get();
      if (!doc.exists) {
        userRef.document(user.uid).setData({
          "id": user.uid,
          "userName": user.displayName,
          "email": user.email,
          "photoUrl": user.photoUrl,
          "bio": "",
          "location": "India",
          "mobile": "",
          "followersCount": 0,
          "followingCount": 0
        });
      }
    }

    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
            getUserID(user);

            return Provider.value(
              value: user,
              child: Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
