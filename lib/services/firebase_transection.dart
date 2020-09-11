import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe/models/recipe.dart';

final Firestore _firestore = Firestore.instance;

class FirebaseTransection {
  void updateView(String id) {
    DocumentReference reference = _firestore.collection("recipes").document(id);

    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(reference);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        await tx
            .update(reference, {'viewCount': postSnapshot['viewCount'] + 1});
        // Delete the recipe ID from 'favorites':
      }
    });
  }

  void updateFollow(String userId, String followersId) {
    DocumentReference referenceUser =
        _firestore.collection("users").document(userId);
    DocumentReference referenceFollowers =
        _firestore.collection("users").document(followersId);

    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(referenceUser);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        await tx.update(referenceUser,
            {'followingCount': postSnapshot['followingCount'] + 1});
        // Delete the recipe ID from 'favorites':
      }
    });
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(referenceFollowers);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        await tx.update(referenceFollowers,
            {'followersCount': postSnapshot['followersCount'] + 1});
        // Delete the recipe ID from 'favorites':
      }
    });
  }

  void updateUnFollow(String userId, String followersId) {
    DocumentReference referenceUser =
        _firestore.collection("users").document(userId);
    DocumentReference referenceFollowers =
        _firestore.collection("users").document(followersId);

    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(referenceUser);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        await tx.update(referenceUser,
            {'followingCount': postSnapshot['followingCount'] - 1});
        // Delete the recipe ID from 'favorites':
      }
    });
    _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(referenceFollowers);
      if (postSnapshot.exists) {
        // Extend 'favorites' if the list does not contain the recipe ID:

        await tx.update(referenceFollowers,
            {'followersCount': postSnapshot['followersCount'] - 1});
        // Delete the recipe ID from 'favorites':
      }
    });
  }
}
