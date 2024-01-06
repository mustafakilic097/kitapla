import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:super_tag_editor/widgets/rich_text_widget.dart';

import '../../../core/model/designModels.dart';


class GroupAddPage extends StatefulWidget {
  const GroupAddPage({super.key});

  @override
  State<GroupAddPage> createState() => _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  int hazirIndex = 0;
  int hazirIndex1 = 0;
  int hazirIndex2 = 1;

  List<String> values = ["ad", "me", "an"];
  List<String> oneriler = ["Adana", "Mustafa", "Deneme", "deneme"];

  TextEditingController tagText = TextEditingController();

  bool focusTagEnabled = false;
  bool herkeseAcik = true;
  bool sadeceDavetle = false;
  bool serbest = true;
  bool sadeceErkek = false;
  bool sadeceKiz = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Grup Oluştur",
            style: GoogleFonts.quicksand(color: Theme.of(context).secondaryHeaderColor),
          ),
          elevation: 0),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            child: Text(
              "Temel Bilgiler",
              style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: borderedContainer(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  FloatingActionButton.large(
                    onPressed: null,
                    backgroundColor: colorCombinations[hazirIndex1],
                    child: Icon(
                      bookIcons[hazirIndex],
                      color: colorCombinations[hazirIndex2],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            // Galeriye Yönlendir
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey.shade900,
                                boxShadow: const [
                                  BoxShadow(offset: Offset(0, 7), blurRadius: 15, color: Colors.black26),
                                ]),
                            child: Text(
                              "📷 Resim Seç",
                              textScaleFactor: 1.2,
                              style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              hazirIndex = Random().nextInt(bookIcons.length);
                              hazirIndex1 = Random().nextInt(colorCombinations.length);
                              hazirIndex2 = Random().nextInt(colorCombinations.length);
                              if (hazirIndex1 == hazirIndex2) {
                                hazirIndex2 = 0;
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(offset: Offset(0, 7), blurRadius: 15, color: Colors.black26),
                                ]),
                            child: Text(
                              "🙂 Simge Ekle",
                              textScaleFactor: 1.2,
                              style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Grup resmini girin (Opsiyonel)",
                      style: textOrta,
                    ),
                  ),
                  const Divider(
                    height: 25,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Grup adını giriniz...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    style: GoogleFonts.quicksand(fontSize: 20),
                  ),
                  const Divider(height: 25),
                  buildTagEditor(),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Grubunuzu daha iyi tanıtmak amaçlı etiket ekleyebilirsiniz.",
                        style: GoogleFonts.quicksand()),
                  ),
                  const Divider(height: 25),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Grup açıklamasını giriniz...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    style: GoogleFonts.quicksand(fontSize: 20),
                    maxLines: 5,
                  ),
                ],
              ),
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            child: Text(
              "Grup Kuralları",
              style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: borderedContainer(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(25)),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        FilterChip(
                            label: Text(
                              "Herkese Açık",
                              style: GoogleFonts.quicksand(color: herkeseAcik ? Colors.green.shade900 : Colors.black),
                            ),
                            selected: herkeseAcik,
                            selectedColor: herkeseAcik ? Colors.green : Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                herkeseAcik = value;
                                sadeceDavetle = !value;
                              });
                            },
                            side: const BorderSide()),
                        FilterChip(
                            label: Text(
                              "Sadece Davetle",
                              style: GoogleFonts.quicksand(color: sadeceDavetle ? Colors.green.shade900 : Colors.black),
                            ),
                            selected: sadeceDavetle,
                            selectedColor: sadeceDavetle ? Colors.green : Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                sadeceDavetle = value;
                                herkeseAcik = !value;
                              });
                            },
                            side: const BorderSide()),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(25)),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        FilterChip(
                            label: Text(
                              "Serbest",
                              style: GoogleFonts.quicksand(color: serbest ? Colors.green.shade900 : Colors.black),
                            ),
                            selected: serbest,
                            selectedColor: serbest ? Colors.green : Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                serbest = value;
                                sadeceErkek = !value;
                                sadeceKiz = !value;
                              });
                            },
                            side: const BorderSide()),
                        FilterChip(
                            label: Text(
                              "Sadece Erkek",
                              style: GoogleFonts.quicksand(color: sadeceErkek ? Colors.green.shade900 : Colors.black),
                            ),
                            selected: sadeceErkek,
                            selectedColor: sadeceErkek ? Colors.green : Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                sadeceErkek = value;
                                serbest = !value;
                                sadeceKiz = !value;
                              });
                            },
                            side: const BorderSide()),
                        FilterChip(
                            label: Text(
                              "Sadece Kız",
                              style: GoogleFonts.quicksand(color: sadeceKiz ? Colors.green.shade900 : Colors.black),
                            ),
                            selected: sadeceKiz,
                            selectedColor: sadeceKiz ? Colors.green : Colors.grey,
                            onSelected: (value) {
                              setState(() {
                                sadeceErkek = !value;
                                serbest = !value;
                                sadeceKiz = value;
                              });
                            },
                            side: const BorderSide()),
                      ],
                    ),
                  ),
                )
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
            child: Text(
              "Katılımcı Ekle",
              style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: borderedContainer(
                child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(
                      "Kullanıcı Adı ile arayın...",
                      style: GoogleFonts.quicksand(fontSize: 20),
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          print("Kullanıcılardan ara");
                        },
                        icon: const Icon(Icons.person_search_rounded)),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: const Text("Mustafa Kılıç"),
                        subtitle: const Text("@mustafa"),
                        trailing: IconButton(
                            onPressed: () {
                              print("Kullanıcıyı ekle");
                            },
                            icon: const Icon(Icons.add)),
                      );
                    },
                    itemCount: 2,
                  ),
                )
              ],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print("Grubu Oluştur");
              },
              child: const Text("Grubu oluştur"),
            ),
          )
        ],
      ),
    );
  }

  TagEditor<String> buildTagEditor() {
    return TagEditor<String>(
      length: values.length,
      controller: tagText,
      delimiters: const [',', ' '],
      hasAddButton: true,
      resetTextOnSubmitted: true,
      textStyle: GoogleFonts.quicksand(),
      onSubmitted: (outstandingValue) {
        setState(() {
          values.add(outstandingValue);
        });
      },
      inputDecoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          labelText: 'Grup Etiketleri',
          labelStyle: GoogleFonts.quicksand(fontSize: 20)),
      onTagChanged: (newValue) {
        setState(() {
          values.add(newValue);
        });
      },
      tagBuilder: (context, index) => Chip(
        label: Text(
          values[index],
          style: GoogleFonts.quicksand(color: Theme.of(context).secondaryHeaderColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onDeleted: () {
          setState(() {
            values.removeAt(index);
          });
        },
      ),
      // InputFormatters example, this disallow \ and /
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))],
      useDefaultHighlight: false,
      suggestionBuilder: (context, state, data, index, length, highlight, suggestionValid) {
        var borderRadius = const BorderRadius.all(Radius.circular(20));
        if (index == 0) {
          borderRadius = const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          );
        } else if (index == length - 1) {
          borderRadius = const BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          );
        }
        return InkWell(
          onTap: () {
            setState(() {
              values.add(data);
            });
            state.resetTextField();
            state.closeSuggestionBox();
          },
          child: Container(
              decoration:
                  highlight ? BoxDecoration(color: Theme.of(context).focusColor, borderRadius: borderRadius) : null,
              padding: const EdgeInsets.all(16),
              child: RichTextWidget(
                wordSearched: suggestionValid ?? '',
                textOrigin: data,
              )),
        );
      },
      onFocusTagAction: (focused) {
        setState(() {
          focusTagEnabled = focused;
        });
      },
      onDeleteTagAction: () {
        if (values.isNotEmpty) {
          setState(() {
            values.removeLast();
          });
        }
      },
      onSelectOptionAction: (item) {
        setState(() {
          values.add(item);
        });
      },
      suggestionsBoxElevation: 10,
      findSuggestions: (String query) {
        if (query.isNotEmpty) {
          var lowercaseQuery = query.toLowerCase();
          return oneriler.where((profile) {
            return profile.toLowerCase().contains(query.toLowerCase()) ||
                profile.toLowerCase().contains(query.toLowerCase());
          }).toList(growable: false)
            ..sort(
                (a, b) => a.toLowerCase().indexOf(lowercaseQuery).compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
        }
        return [];
      },
    );
  }
}

Widget borderedContainer({required Widget child,Alignment? alignment, Color? color}) {
  return Container(
    width: double.infinity,
    alignment: alignment ?? Alignment.center,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: color??Colors.grey.shade200, borderRadius: BorderRadius.circular(25), boxShadow: const [
      // BoxShadow(color: Colors.grey.shade100, offset: const Offset(5, 5), blurRadius: 15),
      // BoxShadow(color: Colors.grey.shade100, offset: const Offset(-5, -5), blurRadius: 15)
    ]),
    child: child,
  );
}
