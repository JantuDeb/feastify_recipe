import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  Recipe({
    this.id,
    this.recipeId,
    this.photoUrl,
    this.recipeTitle,
    this.recipeDescription,
    this.recipeLink,
    this.cookingTime,
    this.createdBy,
    this.serves,
    this.viewCount,
    this.likes,
    this.categories,
    this.ingredients,
    this.methods,
    this.createdAt,
    this.searchQuery,
  });
  final String id;
  final String recipeId;
  final String photoUrl;
  final String recipeTitle;
  final String recipeDescription;
  final String recipeLink;
  final String cookingTime;
  final String createdBy;
  final String serves;
  final int viewCount;
  final int likes;
  final List<String> categories;
  final List<String> ingredients;
  final List<String> methods;
  final List<String> searchQuery;
  final Timestamp createdAt;

  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String recipeId = data['recipeId'];
    final String photoUrl = data['photoUrl'];
    final String recipeTitle = data['recipeTitle'];
    final String recipeDescription = data['recipeDescription'];
    final String recipeLink = data['recipeLink'];
    final String cookingTime = data['cookingTime'];
    final String createdBy = data['createdBy'];
    final String serves = data['serves'];
    final int viewCount = data['viewCount'];
    final int likes = data['likes'];
    final List<String> categories = List.castFrom(data['categories']);
    final List<String> ingredients = List.castFrom(data['ingredients']);
    final List<String> methods = List.castFrom(data['methods']);
    final Timestamp createdAt = data['createdAt'];
    final List<String> searchQuery = List.castFrom(data['searchQuery']);
    return Recipe(
        id: documentId,
        recipeId: recipeId,
        photoUrl: photoUrl,
        recipeTitle: recipeTitle,
        recipeDescription: recipeDescription,
        recipeLink: recipeLink,
        cookingTime: cookingTime,
        createdBy: createdBy,
        serves: serves,
        viewCount: viewCount,
        likes: likes,
        categories: categories,
        ingredients: ingredients,
        methods: methods,
        searchQuery: searchQuery,
        createdAt: createdAt);
  }
  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'photoUrl': photoUrl,
      'recipeTitle': recipeTitle,
      'recipeDescription': recipeDescription,
      'recipeLink': recipeLink,
      'cookingTime': cookingTime,
      'createdBy': createdBy,
      'serves': serves,
      'viewCount': viewCount,
      'likes': likes,
      'categories': categories,
      'ingredients': ingredients,
      'methods': methods,
      'createdAt': createdAt,
      'searchQuery': searchQuery,
    };
  }
}
