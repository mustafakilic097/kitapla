import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/group_model.dart';

class GroupRepository extends ChangeNotifier {
  List<GroupModel> groups = [
    // GroupModel(
    //   groupId: 'unique_group_id', // Benzersiz bir grup kimliği atayın
    //   groupName: 'Roman Okurları',
    //   groupDescription: 'Bu grup roman okumak amaçlı açılmıştır.',
    //   groupAdminId: 'admin_user_id', // Grubun yöneticisi kullanıcı kimliği
    //   memberShipType: MemberShipType.admin, // Kullanıcı tipi: Admin
    //   memberIds: ['admin_user_id'], // Üyelerin kimlikleri, başlangıçta sadece yönetici
    //   createdAt: DateTime.now().toString(), // Oluşturma tarihi
    //   groupImageUrl: null, // Grup resmi URL'si, null olarak başlatılabilir
    //   groupReadStyle: GroupReadStyle.roman, // Okuma tarzı: Roman
    //   groupReadingBook: null, // Grup tarafından okunan kitaplar, null olarak başlatılabilir
    // ),
  ];

  Future<void> setSyncGroupData(List<GroupModel> onlineGroupData, Box<GroupModel> groupBox) async {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(GroupModelAdapter());
    }
    await groupBox.clear();
    await groupBox.addAll(onlineGroupData);
    getLocalGroupData(groupBox);
  }

  List<GroupModel> getLocalGroupData(Box<GroupModel> groupBox) {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(GroupModelAdapter());
    }

    List<GroupModel> groups1 = [];

    for (var i = 0; i < groupBox.length; i++) {
      var gd = groupBox.getAt(i);
      if (gd != null) {
        groups1.add(gd);
      }
    }

    groups.clear();
    groups.addAll(groups1);
    notifyListeners();
    return groups;
  }

  Future<void> getGroupData() async {

  }
}

final groupRepositoryProvider = ChangeNotifierProvider((ref) => GroupRepository());
