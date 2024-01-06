import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';
import '../../core/base/state/base_state.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../explore/share_screen.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavBar,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            changeCurrentIndex(index);
          });
        },
        itemBuilder: (BuildContext context, int index) => index == 0
            ? const ExploreScreen()
            : index == 1
                ? const ChatScreen()
                : index == 2
                    ? const ProfileScreen()
                    : const ProfileScreen(),
        itemCount: 3,
      ),
    );
  }

  Widget get buildBottomNavBar => SweetNavBar(
        currentIndex: currentIndex,
        padding: const EdgeInsets.all(0),
        borderRadius: 0,
        backgroundColor: Colors.white,
        items: [
          SweetNavBarItem(
              sweetIcon: const Icon(CupertinoIcons.home), sweetLabel: 'Ana Sayfa', sweetBackground: Colors.white),
          SweetNavBarItem(
              sweetIcon: const Icon(CupertinoIcons.chat_bubble_text),
              sweetLabel: 'Mesajlar',
              sweetBackground: Colors.white),
          SweetNavBarItem(
              sweetIcon: const Icon(CupertinoIcons.person_crop_circle),
              sweetLabel: 'Profil',
              sweetBackground: Colors.white),
          SweetNavBarItem(
              sweetIcon: const Icon(CupertinoIcons.add_circled_solid, color: Colors.orange),
              iconColors: [Colors.orange, Colors.orange],
              sweetLabel: "Ekle",
              sweetBackground: Colors.white)
        ],
        onTap: (index) {
          if (index == 3) {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => const ShareScreen(),
            ));
          } else {
            pageController?.jumpToPage(index);
          }
        },
      );
}
