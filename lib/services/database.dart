import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/models/user.dart';

import 'package:recipe/services/firestore_service.dart';

import 'api_path.dart';

abstract class Database {
  Future<void> createRecipe(Recipe recipe);
  Future<void> updateUserData(UserData userData);
  Stream<List<Recipe>> readRecipe();
  Stream<List<Recipe>> readUserRecipe();
  Future<String> uploadImageToStorage(File imageFile);
  Future<UserData> getUserById();
  Future<void> removeDocument(String id);
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
  Future<void> updateUserData(UserData userData) async =>
      await _service.setData(
        path: APIPath.userData(userData.id),
        data: userData.toUserMap(),
      );

  Stream<List<Recipe>> readRecipe() => _service.collectionReference(
        path: "recipes",
        builder: (data, documentId) => Recipe.fromMap(data, documentId),
      );

  Stream<List<Recipe>> readUserRecipe() {
    final path = "recipes";
    final reference =
        Firestore.instance.collection(path).where("recipeId", isEqualTo: uid);
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

  Future<DocumentSnapshot> getDocumentById() {
    final path = "users";
    final reference = Firestore.instance.collection(path).document(uid);
    return reference.get();
  }

  Future<void> removeDocument(String id) {
    final path = "recipes";
    final reference = Firestore.instance.collection(path);
    return reference.document(id).delete();
  }

  Future<UserData> getUserById() async {
    var doc = await getDocumentById();
    return UserData.fromUserMap(doc.data, doc.documentID);
  }
}
