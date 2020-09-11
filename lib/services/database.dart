import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/models/user.dart';

import 'package:recipe/services/firestore_service.dart';

import 'api_path.dart';

abstract class Database {
  Future<void> createRecipe(Recipe recipe);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> updateUserData(UserData userData);
  Stream<List<Recipe>> readRecipe();
  Stream<List<Recipe>> readUserRecipe({String userId});
  Future<String> uploadImageToStorage(File imageFile);
  Future<UserData> getUserById({String id});
  Future<void> removeDocument(String id);
  Stream<List<Recipe>> readRecipeByLike();
  Future<List<Recipe>> getSavedRecipes();
  Stream<List<Recipe>> readRecomendedRecipes();
  Future<void> followUser({
    String followingUserId,
    String name,
    String followingName,
    String followingPhotoUrl,
    String photoUrl,
  });
  Future<void> unFollowUser({String followingUserId});
  Future<bool> checkIsFollowing(String followingUserId);
  Future<List<DocumentSnapshot>> followersCount();
  Future<List<DocumentSnapshot>> followingCount();
}

String documentIdFromDTN() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({this.uid});
  final String uid;
  final _service = FirestoreService.instance;
  Future<void> createRecipe(Recipe recipe) async => await _service.setData(
        path: APIPath.recipe(recipe.id),
        data: recipe.toMap(),
      );
  Future<void> updateRecipe(Recipe recipe) async => await _service.updateData(
        path: APIPath.recipe(recipe.id),
        data: recipe.toMap(),
      );
  Future<void> updateUserData(UserData userData) async =>
      await _service.setData(
        path: APIPath.userData(userData.id),
        data: userData.toUserMap(),
      );

  Stream<List<Recipe>> readRecipe() => _service.collectionReference(
        path: "recipes",
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );
  Stream<List<Recipe>> readRecipeByLike() => _service.collectionReferenceByLike(
        path: "recipes",
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );
  Stream<List<Recipe>> readRecomendedRecipes() =>
      _service.collectionReferenceRecomended(
        path: "recipes",
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );
  Stream<List<Recipe>> readUserRecipe({String userId}) {
    final path = "recipes";
    final String id = userId == null ? uid : userId;
    final reference = Firestore.instance
        .collection(path)
        .where("recipeId", isEqualTo: id)
        .orderBy("createdAt", descending: true);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => Recipe.fromMap(snapshot.data, snapshot.documentID),
        )
        .toList());
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    StorageReference _storageReference = FirebaseStorage.instance
        .ref()
        .child('recipeImage/${DateTime.now().millisecondsSinceEpoch}');
    StorageUploadTask storageUploadTask = _storageReference.putFile(imageFile);
    var url = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  // Future<DocumentSnapshot> getDocumentById() {
  //   final path = "users";
  //   final reference = Firestore.instance.collection(path).document(uid);
  //   return reference.get();
  // }

  Future<void> removeDocument(String id) {
    final path = "recipes";
    final reference = Firestore.instance.collection(path);
    return reference.document(id).delete();
  }

  Future<UserData> getUserById({String id}) async {
    final path = "users";
    final String userId = id == null ? uid : id;
    final reference = Firestore.instance.collection(path).document(userId);
    var document = await reference.get();
    // var doc = await getDocumentById();
    return UserData.fromUserMap(document.data, document.documentID);
  }

  Future<List<Recipe>> getSavedRecipes() async {
    final Firestore _firestore = Firestore.instance;
    List<String> recipeIds = List<String>();
    List<Recipe> snapshots = List<Recipe>();
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(uid)
        .collection("saved_recipe")
        .orderBy("createdAt", descending: true)
        .getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      recipeIds.add(querySnapshot.documents[i].documentID);
    }
    for (var i = 0; i < recipeIds.length; i++) {
      DocumentSnapshot postSnapshot =
          await _firestore.collection("recipes").document(recipeIds[i]).get();
      if (postSnapshot.exists) {
        snapshots
            .add(Recipe.fromMap(postSnapshot.data, postSnapshot.documentID));
      }
    }
    return snapshots;
  }

  Future<void> followUser({
    String followingUserId,
    String name,
    String followingName,
    String followingPhotoUrl,
    String photoUrl,
  }) async {
    final Firestore _firestore = Firestore.instance;
    var followingMap = Map<String, String>();
    followingMap['uid'] = followingUserId;
    followingMap['userName'] = followingName;
    followingMap['photoUrl'] = followingPhotoUrl;
    await _firestore
        .collection("users")
        .document(uid)
        .collection("following")
        .document(followingUserId)
        .setData(followingMap, merge: true);

    var followersMap = Map<String, String>();
    followersMap['uid'] = uid;
    followersMap['userName'] = name;
    followersMap['photoUrl'] = photoUrl;

    return _firestore
        .collection("users")
        .document(followingUserId)
        .collection("followers")
        .document(uid)
        .setData(followersMap, merge: true);
  }

  Future<void> unFollowUser({String followingUserId}) async {
    final Firestore _firestore = Firestore.instance;
    await _firestore
        .collection("users")
        .document(uid)
        .collection("following")
        .document(followingUserId)
        .delete();

    return _firestore
        .collection("users")
        .document(followingUserId)
        .collection("followers")
        .document(uid)
        .delete();
  }

  Future<bool> checkIsFollowing(String followingUserId) async {
    bool isFollowing = false;
    // String uid = await fetchUidBySearchedName(name);
    final Firestore _firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(uid)
        .collection("following")
        .getDocuments();

    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID == followingUserId) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  Future<List<DocumentSnapshot>> followersCount() async {
    final Firestore _firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(uid)
        .collection("followers")
        .getDocuments();

    return querySnapshot.documents;
  }

  Future<List<DocumentSnapshot>> followingCount() async {
    final Firestore _firestore = Firestore.instance;
    QuerySnapshot querySnapshot = await _firestore
        .collection("users")
        .document(uid)
        .collection("following")
        .getDocuments();

    return querySnapshot.documents;
  }
}
