// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names
import 'package:flutter/material.dart';

enum CustomListTileType { ROUTER, SWITCH }

class CustomListTile extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final CustomListTileType type;
  final bool? enableSwitch;
  final void Function(bool)? onSwitch;
  final void Function()? onRouter;
  const CustomListTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.type,
    this.enableSwitch,
    this.onSwitch,
    this.onRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == CustomListTileType.ROUTER
        ? ListTile(
            title: title,
            subtitle: subtitle != null ? Text(subtitle ?? "") : null,
            trailing: const Icon(Icons.keyboard_arrow_right_rounded),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            onTap: onRouter,
          )
        : SwitchListTile(
            title: title,
            value: enableSwitch ?? false,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            onChanged: onSwitch,
          );
  }
}
