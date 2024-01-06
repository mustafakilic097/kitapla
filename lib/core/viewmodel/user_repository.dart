import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/user_model.dart';

class UserRepository extends ChangeNotifier {
  // gerek yok yani user'ı cache'lemeye internetle girmesini zorunlu yaparız
  UserModel? localUser;

  Future<void> updateLocalUser({UserModel? user}) async {
    await Hive.initFlutter();
    await Hive.openBox<UserModel>("localUser").then((box) {
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(UserAdapter());
      }
      user != null ? box.put("localUser", user) : null;
      if (box.length > 0) {
        localUser = box.get("localUser");
      }
    });
    notifyListeners();
  }

  List<UserModel> users = [
    UserModel(
        name: "Mustafa",
        surname: "Kılıç",
        status: UserStatus.cevrimici,
        username: "mustafa",
        userId: '1',
        email: 'm@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Oktay",
        surname: "Tultar",
        status: UserStatus.cevrimici,
        username: "oktay",
        userId: '2',
        email: 'o@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Peter",
        surname: "Parker",
        status: UserStatus.cevrimici,
        username: "peter",
        userId: '3',
        email: 'p@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Fatma",
        surname: "Sucu",
        status: UserStatus.cevrimici,
        username: "fatma",
        userId: '4',
        email: 'f@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Salih",
        surname: "Kadir",
        status: UserStatus.cevrimici,
        username: "salih",
        userId: '5',
        email: 's@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Ramazan",
        surname: "Ramazanoğlu",
        status: UserStatus.cevrimici,
        username: "ramazan",
        userId: '6',
        email: 'r@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Oruç",
        surname: "Kebapoğlu",
        status: UserStatus.cevrimici,
        username: "oruc",
        userId: '7',
        email: 'oruc@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "İftar",
        surname: "Büryan",
        status: UserStatus.cevrimici,
        username: "iftar",
        userId: '8',
        email: 'i@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Döner",
        surname: "Ayran",
        status: UserStatus.cevrimici,
        username: "doner",
        userId: '9',
        email: 'd@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Bayram",
        surname: "Galip",
        status: UserStatus.cevrimici,
        username: "bayram",
        userId: '10',
        email: 'b@gmail.com',
        followerIds: [],
        followingIds: []),
    UserModel(
        name: "Erman",
        surname: "Toraman",
        status: UserStatus.cevrimici,
        username: "erman",
        userId: '11',
        email: 'e@gmail.com',
        followerIds: [],
        followingIds: []),
  ];
}

final userRepositoryProvider = ChangeNotifierProvider((ref) => UserRepository());
