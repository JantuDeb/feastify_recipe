class UserData {
  UserData(
      {required this.id,
      required this.followersCount,
      required this.followingCount,
      required this.userName,
      required this.email,
      required this.photoUrl,
      required this.bio,
      required this.mobile,
      required this.location});
  final String id;
  final String userName;
  final String email;
  final String photoUrl;
  final String bio;
  final String mobile;
  final String location;
  final int followersCount;
  final int followingCount;

  factory UserData.fromUserMap(Map<String, dynamic> data, String documentId) {
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
