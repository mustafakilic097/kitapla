import 'package:hive/hive.dart';

enum MemberShipType { uye, admin }

enum GroupReadStyle {
  genel, // Genel
  klasik, // Klasik
  roman, // Roman
  kurgu, // Kurgu
  bilimKurgu, // Bilim Kurgu
  gizem, // Gizem
  romantik, // Romantik
  biyografi, // Biyografi
  kisiselGelisim, // Kendi Gelişimi
  tarihi, // Tarihi
  siir, // Şiir
  cizgiRoman, // Çizgi Roman
  korku, // Korku
  gerilim, // Gerilim
  macera, // Macera
  cocuk, // Çocuk
  genclik, // Gençlik
  diger, // Diğer
}

enum GroupMode { acik, gizli, davetle }

class GroupModel {
  final String groupId;
  final String groupName;
  final String groupDescription;
  final String groupAdminId;
  final MemberShipType memberShipType;
  final List<String> memberIds;
  final String createdAt;
  String? groupImageUrl;
  final GroupReadStyle groupReadStyle;
  List<String>? groupReadingBook;
  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.groupAdminId,
    required this.memberShipType,
    required this.memberIds,
    required this.createdAt,
    this.groupImageUrl,
    required this.groupReadStyle,
    this.groupReadingBook,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupDescription': groupDescription,
      'groupAdminId': groupAdminId,
      'memberShipType': memberShipType.toString(), // Enum değerini string olarak kaydediyoruz
      'memberIds': memberIds,
      'createdAt': createdAt,
      'groupImageUrl': groupImageUrl,
      'groupReadStyle': groupReadStyle.toString(), // Enum değerini string olarak kaydediyoruz
      'groupReadingBook': groupReadingBook,
    };
  }

  static GroupModel fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupId: map['groupId'],
      groupName: map['groupName'],
      groupDescription: map['groupDescription'],
      groupAdminId: map['groupAdminId'],
      memberShipType: map['memberShipType'] == 'MemberShipType.uye'
          ? MemberShipType.uye
          : MemberShipType.admin, // String'i Enum değerine çeviriyoruz
      memberIds: List<String>.from(map['memberIds']),
      createdAt: map['createdAt'],
      groupImageUrl: map['groupImageUrl'],
      groupReadStyle: map['groupReadStyle'] == 'GroupReadStyle.genel'
          ? GroupReadStyle.genel
          : GroupReadStyle.klasik, // String'i Enum değerine çeviriyoruz
      groupReadingBook: map['groupReadingBook'] != null ? List<String>.from(map['groupReadingBook']) : null,
    );
  }
}
class GroupModelAdapter extends TypeAdapter<GroupModel> {
  @override
  final int typeId = 3; // Her sınıf için benzersiz bir typeId atayın.

  @override
  GroupModel read(BinaryReader reader) {
    return GroupModel(
      groupId: reader.read(),
      groupName: reader.read(),
      groupDescription: reader.read(),
      groupAdminId: reader.read(),
      memberShipType: reader.read(),
      memberIds: reader.readStringList(),
      createdAt: reader.read(),
      groupImageUrl: reader.read(),
      groupReadStyle: reader.read(),
      groupReadingBook: reader.readStringList(),
    );
  }

  @override
  void write(BinaryWriter writer, GroupModel obj) {
    writer.write(obj.groupId);
    writer.write(obj.groupName);
    writer.write(obj.groupDescription);
    writer.write(obj.groupAdminId);
    writer.write(obj.memberShipType);
    writer.writeStringList(obj.memberIds);
    writer.write(obj.createdAt);
    writer.write(obj.groupImageUrl);
    writer.write(obj.groupReadStyle);
    writer.writeStringList(obj.groupReadingBook??[]);
  }
}
