import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../model/sharing_model.dart';


class SharingRepository extends ChangeNotifier {
  List<SharingModel> sharesData = [];

    Future<void> setSyncShareData(List<SharingModel> onlineData, Box<SharingModel> shareBox) async {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(SharingTypeAdapter());
    }
    await shareBox.clear();
    // print(onlineData);
    await shareBox.addAll(onlineData);
    getLocalShares(shareBox);
  }

  List<SharingModel> getLocalShares(Box<SharingModel> shareBox) {
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(SharingTypeAdapter());
    }
    List<SharingModel> shares = [];
    for (var i = 0; i < shareBox.length; i++) {
      SharingModel? share = shareBox.getAt(i);
      if (share != null) {
        shares.add(share);
      }
    }
    sharesData.clear();
    sharesData.addAll(shares);
    notifyListeners();
    return sharesData;
  }

}

final sharingRepositoryProvider = ChangeNotifierProvider((ref) => SharingRepository());
