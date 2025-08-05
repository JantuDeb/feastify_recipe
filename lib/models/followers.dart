class Followers {
  Followers({
    required this.id,
    required this.userName,
    required this.photoUrl,
  });
  final String id;
  final String userName;
  final String photoUrl;

  factory Followers.fromFollowersMap(
      Map<String, dynamic> data, String documentId) {
    final String userName = data['userName'];
    final String photoUrl = data['photoUrl'];

    return Followers(
      id: documentId,
      userName: userName,
      photoUrl: photoUrl,
    );
  }
  Map<String, dynamic> toFollowerMap() {
    return {
      'userName': userName,
      'photoUrl': photoUrl,
    };
  }
}
