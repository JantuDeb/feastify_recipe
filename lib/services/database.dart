import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/models/recipe.dart';
import 'package:recipe/services/firestore_service.dart';

import 'api_path.dart';

abstract class Database {
  Future<void> createRecipe(Recipe recipe);
  Stream<List<Recipe>> readRecipe();
  Stream<List<Recipe>> readUserRecipe();
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
}
