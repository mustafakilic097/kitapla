import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/model/user_model.dart';


class UserDetails extends StatefulWidget {
  final UserModel userData;
  const UserDetails({super.key, required this.userData});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

enum MoreMenu { viewContact, media, search, mute, wallpaper, more }

class _UserDetailsState extends State<UserDetails> {
  final List<UserModel> joinedUsers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData.name),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => <PopupMenuEntry<MoreMenu>>[
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.viewContact,
                      child: Text('View contact'),
                    ),
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.media,
                      child: Text('Media'),
                    ),
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.search,
                      child: Text('Search'),
                    ),
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.mute,
                      child: Text('Mute notifications'),
                    ),
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.wallpaper,
                      child: Text('Wallpaper'),
                    ),
                    const PopupMenuItem<MoreMenu>(
                      value: MoreMenu.more,
                      child: ListTile(
                        title: Text("More"),
                        contentPadding: EdgeInsets.all(0.0),
                        trailing: Icon(Icons.arrow_right),
                      ),
                    ),
                  ])
        ],
      ),
      body: Scrollbar(
        thickness: 10,
        radius: const Radius.circular(50),
        thumbVisibility: true,
        interactive: true,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: joinedUsers.length + 5,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(widget.userData.name[0]),
                  ),
                );
              } else if (index == 1) {
                return Text(
                  widget.userData.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                );
              } else if (index == 2) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Grup Numarası: ${widget.userData.username}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: widget.userData.username));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kopyalandı")));
                            },
                            icon: const Icon(Icons.copy)),
                      ],
                    ),
                  ),
                );
              } else if (index == 3) {
                return Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: const EdgeInsets.only(right: 4, left: 4, bottom: 4),
                              child: const Text(
                                "Açıklama",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Text(widget.userData.status.name)
                        ],
                      ),
                    )
                  )
                );
              } else if (index == 4) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.only(right: 4, left: 4, bottom: 4),
                    // alignment: Alignment.centerLeft,
                    child: const Text(
                      "Katılımcılar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ),
                );
              }
              index -= 5;
              if (index > 9) {
                return ListTile(
                  title: Text(
                    "Devamını Göster(${joinedUsers.length - 10})",
                    style: const TextStyle(color: Colors.blue),
                  ),
                );
              }
              return SizedBox(
                height: 50,
                child: ListTile(
                  leading: joinedUsers[index].profileImageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(joinedUsers[index].profileImageUrl!),
                        )
                      : CircleAvatar(child: Text(joinedUsers[index].name[0])),
                  title: Text("${joinedUsers[index].name} ${joinedUsers[index].surname}"),
                  onTap: () {
                    
                  },
                ),
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
