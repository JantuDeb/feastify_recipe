class Followers {
  Followers({
    this.id,
    this.userName,
    this.photoUrl,
  });
  final id;
  final String userName;

  final String photoUrl;

  factory Followers.fromFollowersMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
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
