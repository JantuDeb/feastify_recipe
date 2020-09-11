import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path:$data');
    await reference.setData(data, merge: true);
  }

  Future<void> updateData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path:$data');
    await reference.updateData(data);
  }

  Stream<List<T>> collectionReference<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    // final path = "recipes";
    // DateTime _now = DateTime.now();
    // DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    // DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

    final reference = Firestore.instance
        .collection(path)
        .limit(20)
        // .where("createdAt", isGreaterThanOrEqualTo: _start)
        // .where("createdAt", isLessThanOrEqualTo: _end)
        .orderBy('createdAt', descending: true);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }

  Stream<List<T>> collectionReferenceByLike<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    // final path = "recipes";
    final reference = Firestore.instance
        .collection(path)
        .orderBy("likeCount", descending: true)
        .limit(10);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }

  Stream<List<T>> collectionReferenceRecomended<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentId),
  }) {
    // final path = "recipes";
    final reference = Firestore.instance
        .collection(path)
        .orderBy("viewCount", descending: true)
        .limit(10);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
        )
        .toList());
  }
}
