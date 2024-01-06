import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'books_screen.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  List<Map<String, String>> topYazarlar = [
    {
      "name": "Orhan Pamuk",
      "image":
          "https://www.harvardmagazine.com/sites/default/files/styles/4x3_main/public/img/story/1209/0909_12f_1.jpg"
    },
    {"name": "Yaşar Kemal", "image": "https://www.biyografi.info/personpicture-fb/yasarkemal.jpg"},
    {
      "name": "Nâzım Hikmet",
      "image": "https://upload.wikimedia.org/wikipedia/en/thumb/b/b8/NazimHikmetRan.jpg/220px-NazimHikmetRan.jpg"
    },
    {"name": "Sabahattin Ali", "image": "https://upload.wikimedia.org/wikipedia/tr/f/f6/Sabahattin_ali.jpg"},
    {
      "name": "Ahmet Hamdi Tanpınar",
      "image":
          "https://i.tmgrup.com.tr/fikriyat/album/2020/01/24/ahmet-hamdi-tanpinar-kimdir-ahmet-hamdi-tanpinarin-hayati-1579847769060.jpg"
    },
  ];
  List<Map<String, String>> sortedYazarlar = [
    {'name': 'Cemal Süreya', 'image': ''},
    {'name': 'Peyami Safa', 'image': ''},
    {'name': 'Oğuz Atay', 'image': ''},
    {'name': 'Necip Fazıl Kısakürek', 'image': ''},
    {'name': 'Refik Halit Karay', 'image': ''},
    {'name': 'Canan Tan', 'image': ''},
    {'name': 'Adalet Ağaoğlu', 'image': ''},
    {'name': 'Murathan Mungan', 'image': ''},
    {'name': 'Bilge Karasu', 'image': ''},
    {'name': 'Kemal Tahir', 'image': ''},
    {'name': 'Halide Edip Adıvar', 'image': ''},
    {'name': 'Haldun Taner', 'image': ''},
    {'name': 'Sait Faik Abasıyanık', 'image': ''},
    {'name': 'İhsan Oktay Anar', 'image': ''},
    {'name': 'Ayşe Kulin', 'image': ''},
    {'name': 'Tahsin Yücel', 'image': ''},
    {'name': 'Kemal Bilbaşar', 'image': ''},
    {'name': 'Samiha Ayverdi', 'image': ''},
    {'name': 'Yusuf Atılgan', 'image': ''},
    {'name': 'Ayşe Sasa', 'image': ''},
    {'name': 'Sevgi Soysal', 'image': ''},
    {'name': 'Hakan Günday', 'image': ''},
    {'name': 'Sunay Akın', 'image': ''},
    {'name': 'Rasim Özdenören', 'image': ''},
    {'name': 'Emrah Serbes', 'image': ''},
    {'name': 'İskender Pala', 'image': ''},
    {'name': 'Tarık Buğra', 'image': ''},
    {'name': 'Aşık Veysel', 'image': ''},
    {'name': 'İsmet Özel', 'image': ''},
    {'name': 'Adalet Agaoglu', 'image': ''},
    {'name': 'İlhan Berk', 'image': ''},
    {'name': 'Ferit Edgü', 'image': ''},
    {'name': 'Latife Tekin', 'image': ''},
    {'name': 'Sevim Ak', 'image': ''},
    {'name': 'Tomris Uyar', 'image': ''},
    {'name': 'Reşat Nuri Güntekin', 'image': ''},
    {'name': 'Hasan Ali Toptaş', 'image': ''},
    {'name': 'Osman Pamukoğlu', 'image': ''},
    {'name': 'Ayfer Tunç', 'image': ''},
    {'name': 'İhsan Eliaçık', 'image': ''},
    {'name': 'Mehmet Akif Ersoy', 'image': ''},
    {'name': 'Ahmet Ümit', 'image': ''},
    {'name': 'Nezihe Meriç', 'image': ''},
    {'name': 'Ahmet Midhat Efendi', 'image': ''},
    {'name': 'Ahmet Arif', 'image': ''},
    {'name': 'Pınar Kür', 'image': ''},
    {'name': 'Attila İlhan', 'image': ''},
    {'name': 'Kemal Özer', 'image': ''},
    {'name': 'İsmet Küntay', 'image': ''},
    {'name': 'Hilmi Yavuz', 'image': ''},
    {'name': 'Murat Gülsoy', 'image': ''},
    {'name': 'Oruç Aruoba', 'image': ''},
    {'name': 'Aslı Erdoğan', 'image': ''},
    {'name': 'Nedim Gürsel', 'image': ''},
    {'name': 'Ümit Yaşar Oğuzcan', 'image': ''},
    {'name': 'Tarık Dursun K.', 'image': ''},
    {'name': 'Emine Sevgi Özdamar', 'image': ''},
    {'name': 'Ziya Gökalp', 'image': ''},
    {'name': 'Hasan Hüseyin Korkmazgil', 'image': ''},
    {'name': 'Erendiz Atasü', 'image': ''},
    {'name': 'Bülent Ortaçgil', 'image': ''},
    {'name': 'Erdal Öz', 'image': ''},
    {'name': 'Rıfat Ilgaz', 'image': ''},
    {'name': 'Sezai Karakoç', 'image': ''},
    {'name': 'Şule Gürbüz', 'image': ''},
    {'name': 'Muazzez İlmiye Çığ', 'image': ''},
    {'name': 'Aşık Mahzuni Şerif', 'image': ''},
    {'name': 'Melih Cevdet Anday', 'image': ''},
    {'name': 'Mina Urgan', 'image': ''},
    {'name': 'Refik Durbaş', 'image': ''},
    {'name': 'Ümit Kaftancıoğlu', 'image': ''},
    {'name': 'Lale Müldür', 'image': ''},
    {'name': 'Şükrü Erbaş', 'image': ''},
    {'name': 'Enis Batur', 'image': ''},
    {'name': 'Bejan Matur', 'image': ''},
    {'name': 'Murat Uyurkulak', 'image': ''},
    {'name': 'Ahmet Hamdi Gezgin', 'image': ''},
    {'name': 'Sezgin Kaymaz', 'image': ''},
    {'name': 'Ayfer Tunc', 'image': ''},
  ];
  List<Map<String, String>> yazarlar = [
    {'name': 'Cemal Süreya', 'image': ''},
    {'name': 'Peyami Safa', 'image': ''},
    {'name': 'Oğuz Atay', 'image': ''},
    {'name': 'Necip Fazıl Kısakürek', 'image': ''},
    {'name': 'Refik Halit Karay', 'image': ''},
    {'name': 'Canan Tan', 'image': ''},
    {'name': 'Adalet Ağaoğlu', 'image': ''},
    {'name': 'Murathan Mungan', 'image': ''},
    {'name': 'Bilge Karasu', 'image': ''},
    {'name': 'Kemal Tahir', 'image': ''},
    {'name': 'Halide Edip Adıvar', 'image': ''},
    {'name': 'Haldun Taner', 'image': ''},
    {'name': 'Sait Faik Abasıyanık', 'image': ''},
    {'name': 'İhsan Oktay Anar', 'image': ''},
    {'name': 'Ayşe Kulin', 'image': ''},
    {'name': 'Tahsin Yücel', 'image': ''},
    {'name': 'Kemal Bilbaşar', 'image': ''},
    {'name': 'Samiha Ayverdi', 'image': ''},
    {'name': 'Yusuf Atılgan', 'image': ''},
    {'name': 'Ayşe Sasa', 'image': ''},
    {'name': 'Sevgi Soysal', 'image': ''},
    {'name': 'Hakan Günday', 'image': ''},
    {'name': 'Sunay Akın', 'image': ''},
    {'name': 'Rasim Özdenören', 'image': ''},
    {'name': 'Emrah Serbes', 'image': ''},
    {'name': 'İskender Pala', 'image': ''},
    {'name': 'Tarık Buğra', 'image': ''},
    {'name': 'Aşık Veysel', 'image': ''},
    {'name': 'İsmet Özel', 'image': ''},
    {'name': 'Adalet Agaoglu', 'image': ''},
    {'name': 'İlhan Berk', 'image': ''},
    {'name': 'Ferit Edgü', 'image': ''},
    {'name': 'Latife Tekin', 'image': ''},
    {'name': 'Sevim Ak', 'image': ''},
    {'name': 'Tomris Uyar', 'image': ''},
    {'name': 'Reşat Nuri Güntekin', 'image': ''},
    {'name': 'Hasan Ali Toptaş', 'image': ''},
    {'name': 'Osman Pamukoğlu', 'image': ''},
    {'name': 'Ayfer Tunç', 'image': ''},
    {'name': 'İhsan Eliaçık', 'image': ''},
    {'name': 'Mehmet Akif Ersoy', 'image': ''},
    {'name': 'Ahmet Ümit', 'image': ''},
    {'name': 'Nezihe Meriç', 'image': ''},
    {'name': 'Ahmet Midhat Efendi', 'image': ''},
    {'name': 'Ahmet Arif', 'image': ''},
    {'name': 'Pınar Kür', 'image': ''},
    {'name': 'Attila İlhan', 'image': ''},
    {'name': 'Kemal Özer', 'image': ''},
    {'name': 'İsmet Küntay', 'image': ''},
    {'name': 'Hilmi Yavuz', 'image': ''},
    {'name': 'Murat Gülsoy', 'image': ''},
    {'name': 'Oruç Aruoba', 'image': ''},
    {'name': 'Aslı Erdoğan', 'image': ''},
    {'name': 'Nedim Gürsel', 'image': ''},
    {'name': 'Ümit Yaşar Oğuzcan', 'image': ''},
    {'name': 'Tarık Dursun K.', 'image': ''},
    {'name': 'Emine Sevgi Özdamar', 'image': ''},
    {'name': 'Ziya Gökalp', 'image': ''},
    {'name': 'Hasan Hüseyin Korkmazgil', 'image': ''},
    {'name': 'Erendiz Atasü', 'image': ''},
    {'name': 'Bülent Ortaçgil', 'image': ''},
    {'name': 'Erdal Öz', 'image': ''},
    {'name': 'Rıfat Ilgaz', 'image': ''},
    {'name': 'Sezai Karakoç', 'image': ''},
    {'name': 'Şule Gürbüz', 'image': ''},
    {'name': 'Muazzez İlmiye Çığ', 'image': ''},
    {'name': 'Aşık Mahzuni Şerif', 'image': ''},
    {'name': 'Melih Cevdet Anday', 'image': ''},
    {'name': 'Mina Urgan', 'image': ''},
    {'name': 'Refik Durbaş', 'image': ''},
    {'name': 'Ümit Kaftancıoğlu', 'image': ''},
    {'name': 'Lale Müldür', 'image': ''},
    {'name': 'Şükrü Erbaş', 'image': ''},
    {'name': 'Enis Batur', 'image': ''},
    {'name': 'Bejan Matur', 'image': ''},
    {'name': 'Murat Uyurkulak', 'image': ''},
    {'name': 'Ahmet Hamdi Gezgin', 'image': ''},
    {'name': 'Sezgin Kaymaz', 'image': ''},
    {'name': 'Ayfer Tunc', 'image': ''},
  ];

  int selectedSort = 0;

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.grey.shade900,
              title: Text(
                "Yazarlar",
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              centerTitle: true,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 16, top: 4),
                    child: TextField(
                      controller: search,
                      onChanged: (value) {
                        if (search.text == "") {
                          sortedYazarlar.clear();
                          sortedYazarlar.addAll(yazarlar);
                        }
                        List<Map<String, String>> newList = [];
                        for (var i = 0; i < yazarlar.length; i++) {
                          if ((yazarlar[i]["name"] ?? "").toLowerCase().contains(search.text.toLowerCase())) {
                            newList.add(yazarlar[i]);
                          }
                        }
                        sortedYazarlar.clear();
                        sortedYazarlar.addAll(newList);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          suffixIcon: IconButton(
                              onPressed: () {
                                if (search.text == "") {
                                  sortedYazarlar.clear();
                                  sortedYazarlar.addAll(yazarlar);
                                }
                                List<Map<String, String>> newList = [];
                                for (var i = 0; i < yazarlar.length; i++) {
                                  if ((yazarlar[i]["name"] ?? "").toLowerCase().contains(search.text.toLowerCase())) {
                                    newList.add(yazarlar[i]);
                                  }
                                }
                                sortedYazarlar.clear();
                                sortedYazarlar.addAll(newList);
                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.search,
                              )),
                          hintText: "Yazarlarda ara...",
                          hintStyle: GoogleFonts.quicksand(),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(15)),
                          contentPadding: const EdgeInsets.all(8)),
                    ),
                  )),
            ),
            const SliverPadding(padding: EdgeInsets.all(8)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  itemCount: topYazarlar.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksScreen(yazar: topYazarlar[index]["name"]),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(topYazarlar[index]["image"] ?? "",
                                          cacheKey: topYazarlar[index]["image"] ?? ""),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            SizedBox(
                              width: 100,
                              child: Center(
                                child: Text(
                                  topYazarlar[index]["name"] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ];
        },
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16.0, bottom: 5),
                alignment: Alignment.centerLeft,
                child: PopupMenuButton(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(245, 245, 245, 1), borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "  Sıralama: ${selectedSort == 0 ? "Popüleriğe göre" : "Alfabeye göre"} ",
                      style: GoogleFonts.quicksand(fontSize: 18),
                    ),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Text("Popülerliğe göre"),
                        onTap: () {
                          setState(() {
                            sortedYazarlar.clear();
                            sortedYazarlar.addAll(yazarlar);
                            selectedSort = 0;
                          });
                        },
                      ),
                      PopupMenuItem(
                        child: const Text("Alfabeye göre"),
                        onTap: () {
                          setState(() {
                            sortedYazarlar.sort(
                              (a, b) =>
                                  a["name"]!.toString().toLowerCase().compareTo(b["name"]!.toString().toLowerCase()),
                            );
                            selectedSort = 1;
                          });
                        },
                      )
                    ];
                  },
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sortedYazarlar.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return InkWell(
                        onTap: () {
                          TextEditingController manuelAuthor = TextEditingController();
                          buildBottomSheet(context, manuelAuthor);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Column(
                            children: [
                              Container(
                                height: 90,
                                width: 75,
                                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
                                child: const Icon(Icons.search),
                              ),
                              Flexible(
                                child: Text(
                                  "Arama Yapın...",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    index--;
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BooksScreen(yazar: sortedYazarlar[index]["name"]),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Column(
                          children: [
                            Container(
                              height: 90,
                              width: 75,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: Image.network(sortedYazarlar[index]["image"] == ""
                                              ? "https://cdn-icons-png.flaticon.com/128/9977/9977254.png"
                                              : sortedYazarlar[index]["image"]!)
                                          .image,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            Flexible(
                              child: Text(
                                sortedYazarlar[index]["name"] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildBottomSheet(BuildContext context, TextEditingController manuelAuthor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BottomSheet(
            onClosing: () => print("ASFAFSa"),
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Aradığınız yazarın tam adını girin...",
                    style: GoogleFonts.quicksand(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoTextField(
                      autofocus: true,
                      controller: manuelAuthor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        label: const Text("İptal"),
                        icon: const Icon(Icons.close),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextButton.icon(
                            onPressed: () {
                              if (manuelAuthor.text.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BooksScreen(yazar: manuelAuthor.text),
                                    ));
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.blue.shade50),
                                foregroundColor: const MaterialStatePropertyAll(Color.fromRGBO(13, 71, 161, 1))),
                            icon: const Icon(Icons.search),
                            label: const Text("Ara")),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
