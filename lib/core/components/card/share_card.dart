import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../view/explore/share_details_screen.dart';
import '../../init/navigation/navigation_manager.dart';
import '../../model/sharing_model.dart';
import '../../model/user_model.dart';
import '../../viewmodel/database.dart';
import '../../viewmodel/utils.dart';

Widget buildShareCard(
    {required BuildContext context,
    required SharingModel shareData,
    bool isInDetail = false,
    required String shareId,
    required String userId}) {
  return StatefulBuilder(
    builder: (context, setState) => InkWell(
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFF000000), width: 0.1, strokeAlign: -2)),
      onTap: !isInDetail
          ? () async {
              await Get.toNamed(NavigationManager.getShareDetailRoute, arguments: [shareData, shareId]);
            }
          : null,
      child: Ink(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: const AssetImage("assets/user.png"),
                        child: FutureBuilder(
                          future: Db().getUserDetail(shareData.userId),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }
                            UserModel? user = snapshot.data;
                            if (user == null) {
                              return const SizedBox.shrink();
                            }
                            return Image.network(
                              user.profileImageUrl != null ? user.profileImageUrl! : "",
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person_rounded, color: Colors.white);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: LinearProgressIndicator(),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          shareData.sharingName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(
                        "•",
                        style: TextStyle(fontSize: 25, color: Color.fromRGBO(112, 112, 112, 0.902)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          getRelativeTime(shareData.shareTime),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.more_vert_outlined,
                        )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    shareData.shareText,
                    style: GoogleFonts.quicksand(fontSize: 16, fontWeight: FontWeight.w500),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () async {
                      if (shareData.likedUsers.contains(userId)) {
                        setState(() {
                          shareData.likedUsers.remove(userId);
                        });
                        await Db().removeLikeShare(shareId, userId);
                      } else {
                        setState(() {
                          shareData.likedUsers.add(userId);
                        });
                        await Db().sentLikeShare(shareId, userId);
                      }
                    },
                    icon: shareData.likedUsers.contains(userId)
                        ? const Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                          )
                        : const Icon(CupertinoIcons.heart)),
                IconButton(
                    onPressed: !isInDetail
                        ? () async {
                            await Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return const ShareDetailScreen();
                                },
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return SlideTransition(
                                    position: animation.drive(
                                        Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                                            .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                                    child: child,
                                  );
                                },
                              ),
                            ).then((value) => setState(() {}));
                          }
                        : null,
                    icon: const Icon(CupertinoIcons.chat_bubble)),
                IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.repeat)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded)),
              ],
            ),
            Row(
              children: [
                shareData.comments.isNotEmpty
                    ? TextButton(
                        onPressed: !isInDetail
                            ? () async {
                                await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return const ShareDetailScreen();
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: animation.drive(
                                            Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                                                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut))),
                                        child: child,
                                      );
                                    },
                                  ),
                                ).then((value) => setState(() {}));
                              }
                            : null,
                        child: Text(
                          "${shareData.comments.length} yorum",
                          style: GoogleFonts.quicksand(color: Colors.grey.shade700),
                        ))
                    : const SizedBox.shrink(),
                shareData.comments.isNotEmpty && shareData.likedUsers.isNotEmpty
                    ? const Text(
                        "•",
                        style: TextStyle(fontSize: 15, color: Color.fromRGBO(112, 112, 112, 0.326)),
                      )
                    : const SizedBox.shrink(),
                shareData.likedUsers.isNotEmpty
                    ? TextButton(
                        onPressed: () {
                          showLikedUsersDialog(
                              context: context, size: MediaQuery.sizeOf(context), users: shareData.likedUsers);
                        },
                        child: Text(
                          "${shareData.likedUsers.length} beğeni",
                          style: GoogleFonts.quicksand(color: Colors.grey.shade700),
                        ))
                    : const SizedBox.shrink(),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
