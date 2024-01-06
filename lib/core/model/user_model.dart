import 'package:hive/hive.dart';

enum UserStatus { cevrimici, cevrimdisi, okuyor, rahatsizEtme, mesgul, disarida }

@HiveType(typeId: 1)
class UserModel {
  final String userId;
  final String name;
  final String surname;
  final String username;
  final String email;
  final UserStatus status;
  String? profileImageUrl;
  String? thumbnailImageUrl;
  final List<String> followerIds;
  final List<String> followingIds;
  Map<String, String>? detailInfo;
  UserModel({
    required this.userId,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.status,
    this.profileImageUrl,
    this.thumbnailImageUrl,
    required this.followerIds,
    required this.followingIds,
    this.detailInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "name": name,
      "surname": surname,
      "username": username,
      "email": email,
      "status": status.toString(), // Enum değerini string olarak kaydediyoruz
      "profileImageUrl": profileImageUrl,
      "thumbnailImageUrl": thumbnailImageUrl,
      "followerIds": followerIds,
      "followingIds": followingIds,
      "detailInfo": detailInfo,
    };
  }

  // Haritadan nesneye dönüştürme fonksiyonu
  factory UserModel.fromMap(Map<String, dynamic> map) {
    UserStatus userStatus = UserStatus.cevrimici;
    switch (map["status"]) {
      case "UserStatus.cevrimici":
        userStatus = UserStatus.cevrimici;
        break;
      case "UserStatus.cevrimdisi":
        userStatus = UserStatus.cevrimdisi;
        break;
      case "UserStatus.okuyor":
        userStatus = UserStatus.okuyor;
        break;
      case "UserStatus.mesgul":
        userStatus = UserStatus.mesgul;
        break;
      case "UserStatus.disarida":
        userStatus = UserStatus.disarida;
        break;
      case "UserStatus.rahatsizEtme":
        userStatus = UserStatus.rahatsizEtme;
        break;
      default:
        break;
    }
    return UserModel(
        email: map["email"],
        followerIds: List<String>.from(map["followerIds"]),
        followingIds: List<String>.from(map["followingIds"]),
        name: map["name"],
        status: userStatus,
        surname: map["surname"],
        userId: map["userId"],
        username: map["username"],
        detailInfo: map["detailInfo"],
        profileImageUrl: map["profileImageUrl"],
        thumbnailImageUrl: map["thumbnailImageUrl"]);
  }
}

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      userId: reader.readString(),
      name: reader.readString(),
      surname: reader.readString(),
      username: reader.readString(),
      email: reader.readString(),
      status: _readUserStatus(reader), // _readUserStatus fonksiyonunu kullanarak enum değerini okuyoruz
      followerIds: reader.readStringList(),
      followingIds: reader.readStringList(),
    );
  }

  UserStatus _readUserStatus(BinaryReader reader) {
    final index = reader.readInt();
    return UserStatus.values[index];
  }

  @override
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.userId);
    writer.writeString(obj.name);
    writer.writeString(obj.surname);
    writer.writeString(obj.username);
    writer.writeString(obj.email);
    writer.writeInt(obj.status.index); // Enum değerini indeks olarak kaydediyoruz
    writer.writeStringList(obj.followerIds);
    writer.writeStringList(obj.followingIds);
  }
}
