import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  Recipe({
    required this.id,
    required this.recipeId,
    required this.photoUrl,
    required this.recipeTitle,
    required this.recipeDescription,
    required this.recipeLink,
    required this.cookingTime,
    required this.createdBy,
    required this.serves,
    required this.viewCount,
    required this.likes,
    required this.likeCount,
    required this.categories,
    required this.ingredients,
    required this.methods,
    required this.createdAt,
    required this.searchQuery,
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
  final int likeCount;
  final Map likes;
  final List<String> categories;
  final List<String> ingredients;
  final List<String> methods;
  final List<String> searchQuery;
  final Timestamp createdAt;

  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
    final String recipeId = data['recipeId'];
    final String photoUrl = data['photoUrl'];
    final String recipeTitle = data['recipeTitle'];
    final String recipeDescription = data['recipeDescription'];
    final String recipeLink = data['recipeLink'];
    final String cookingTime = data['cookingTime'];
    final String createdBy = data['createdBy'];
    final String serves = data['serves'];
    final int viewCount = data['viewCount'];
    final int likeCount = data['likeCount'];
    final Map likes = data['likes'];
    final List<String> categories = List.from(data['categories']);
    final List<String> ingredients = List.from(data['ingredients']);
    final List<String> methods = List.from(data['methods']);
    final Timestamp createdAt = data['createdAt'];
    final List<String> searchQuery = List.from(data['searchQuery']);
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
        likeCount: likeCount,
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
      'likeCount': likeCount,
      'categories': categories,
      'ingredients': ingredients,
      'methods': methods,
      'createdAt': createdAt,
      'searchQuery': searchQuery,
    };
  }
}
