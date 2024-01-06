import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';

import 'group_add_screen.dart';

class GroupSearch extends StatelessWidget {
  const GroupSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grup Ara"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(25)),
                  suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.search))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FilterChip(
                label: const Text("Etiketlere göre ara"),
                onSelected: (bool value) {},
              ),
              FilterChip(
                label: const Text("Grup koduna göre ara"),
                onSelected: (bool value) {},
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        // leading: CircleAvatar(
                        //   minRadius: 20,
                        //   child: Text("A",style: GoogleFonts.quicksand(fontSize: 10,fontWeight: FontWeight.bold),),
                        // ),
                        leading: const CircleAvatar(
                          child: Text("A.G"),
                        ),
                        title: Text(
                          "Adanalılar Grubu",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Bu grup açıklamasına göre bu gruptaki açıklama böyledir",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.quicksand(fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return const Card(
                              color: Colors.grey,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text("YABAN"),
                                ),
                              ),
                            );
                          },
                          itemCount: 10,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Chip(
                            label: Text("Sadece Davetle"),
                            backgroundColor: Colors.amber,
                          ),
                          Chip(
                            label: Text("Sadece Erkek"),
                            backgroundColor: Colors.amber,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: () {}, child: const Text("Detaylar")),
                          TextButton(onPressed: () {}, child: const Text("Gruba katıl")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  NDialog katilVeyaOlusturDialog(context) {
    return NDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text("Grup Oluştur"),
            leading: const Icon(Icons.add_rounded),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GroupAddPage(),
              ));
            },
          ),
          ListTile(
            title: const Text("Grup Ara"),
            leading: const Icon(Icons.search_rounded),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GroupSearch(),
              ));
            },
          )
        ],
      ),
    );
  }
}
