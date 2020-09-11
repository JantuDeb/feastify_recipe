class UserData {
  UserData(
      {this.id,
      this.followersCount,
      this.followingCount,
      this.userName,
      this.email,
      this.photoUrl,
      this.bio,
      this.mobile,
      this.location});
  final id;
  final String userName;
  final String email;
  final String photoUrl;
  final String bio;
  final String mobile;
  final String location;
  final int followersCount;
  final int followingCount;

  factory UserData.fromUserMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String userName = data['userName'];
    final String photoUrl = data['photoUrl'];
    final String email = data['email'];
    final String bio = data['bio'];
    final String mobile = data['mobile'];
    final String location = data['location'];
    final int followersCount = data['followersCount'];
    final int followingCount = data['followingCount'];

    return UserData(
        id: documentId,
        userName: userName,
        photoUrl: photoUrl,
        email: email,
        bio: bio,
        mobile: mobile,
        location: location,
        followersCount: followersCount,
        followingCount: followingCount);
  }
  Map<String, dynamic> toUserMap() {
    return {
      'userName': userName,
      'photoUrl': photoUrl,
      'email': email,
      'bio': bio,
      'mobile': mobile,
      'location': location,
    };
  }
}
