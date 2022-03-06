class UserInfomation {

  String userID;
  String bio;
  String gender;
  String birthday;
  List<String> tags;

  UserInfomation(String userID, String bio, String gender, String birthday, List<String> tags){
    this.birthday = birthday;
    this.userID = userID;
    this.gender = gender;
    this.bio = bio;
    this.tags = tags;
  }

  @override
  String toString(){
    return 'User: {userID: ${userID}, gender: ${gender}, birthday: ${birthday}, tags: ${tags}, bio: ${bio}}';
  }

}