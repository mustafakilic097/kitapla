import 'package:get/get.dart';
import 'package:kitapla/core/init/connectivity/connectivity.dart';
import 'package:kitapla/view/explore/explore_screen.dart';
import 'package:kitapla/view/explore/share_details_screen.dart';

import '../../../view/auth/widget_tree.dart';
import '../../../view/home/home_screen.dart';

class NavigationManager {
  static final NavigationManager _instance = NavigationManager._init();
  static NavigationManager get instance => _instance;
  NavigationManager._init();

  static String get getHomeRoute => "/";
  static String get getAuthRoute => "/auth";
  static String get getExploreRoute => "/explore";
  static String get getShareDetailRoute => "/explore/share";

  static List<GetPage> get routes => [
        GetPage(
          name: getHomeRoute,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: getAuthRoute,
          page: () => const ConnectivityProvider(child: WidgetTree()),
        ),
        GetPage(
          name: getExploreRoute,
          page: () => const ExploreScreen(),
        ),
        GetPage(
          name: getShareDetailRoute,
          page: () => const ShareDetailScreen(),
          transition: Transition.rightToLeft,
        ),
      ];
}
