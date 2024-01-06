import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class NoteSettings extends StatelessWidget {
  const NoteSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Not ayarları"),),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Herşeyi Sıfırla"),
            onTap: () {
              Hive.deleteBoxFromDisk("notes");
            },
          )
        ],
      ),
    );
  }
}
