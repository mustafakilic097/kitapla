// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'comment_model.dart';


enum ShareAccessType { public, private }

class SharingModel {
  final String userId;
  final String sharingName;
  final DateTime shareTime;
  final ShareAccessType shareAccessType;
  List<String> likedUsers;
  List<String> resharedUsers;
  List<String> resenderUsers;
  String shareText;
  String? shareBookName;
  String? shareAuthorName;
  List<CommentModel> comments;

  SharingModel({
    required this.userId,
    required this.sharingName,
    required this.shareTime,
    required this.shareAccessType,
    required this.likedUsers,
    required this.resharedUsers,
    required this.resenderUsers,
    required this.shareText,
    this.shareBookName,
    this.shareAuthorName,
    required this.comments,
  });

  factory SharingModel.fromMap(Map<String, dynamic> map) {
    List<String> strComs = List<String>.from(map["comments"]);
    List<CommentModel> coms = [];
    for (var com in strComs) {
      coms.add(CommentModel.fromMap(jsonDecode(com)));
    }
    return SharingModel(
        userId: map['userId'],
        shareTime: (map['shareTime'] as Timestamp).toDate(),
        sharingName: map["sharingName"],
        shareAccessType:
            map["shareAccessType"] == "ShareAccessType.public" ? ShareAccessType.public : ShareAccessType.private,
        likedUsers: List<String>.from(map['likedUsers'] ?? []),
        resharedUsers: List<String>.from(map['resharedUsers'] ?? []),
        resenderUsers: List<String>.from(map['resenderUsers'] ?? []),
        shareText: map['shareText'],
        shareBookName: map['shareBookName'] ?? "",
        shareAuthorName: map['shareAuthorName'] ?? "",
        comments: coms);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'shareTime': shareTime,
      "sharingName": sharingName,
      "shareAccessType": shareAccessType.name == "public" ? "ShareAccessType.public" : "ShareAccessType.private",
      'likedUsers': likedUsers,
      "resharedUsers": resharedUsers,
      "resenderUsers": resenderUsers,
      'shareText': shareText,
      'shareBookName': shareBookName,
      'shareAuthorName': shareAuthorName,
      "comments": comments
    };
  }
}

@HiveType(typeId: 6)
class SharingTypeAdapter extends TypeAdapter<SharingModel> {
  @override
  int get typeId => 6;

  @override
  SharingModel read(BinaryReader reader) {
    final userId = reader.readString();
    final shareTime = reader.read();
    final sharingName = reader.readString();
    final shareAccessType = reader.readString();
    final likedUsers = reader.readStringList();
    final resharedUsers = reader.readStringList();
    final resenderUsers = reader.readStringList();
    final shareText = reader.readString();
    final shareBookName = reader.readString();
    final shareAuthorName = reader.readString();
    final comments = reader.read();
    return SharingModel(
        userId: userId,
        shareTime: shareTime,
        sharingName: sharingName,
        shareAccessType: shareAccessType == "ShareAccessType.public" ? ShareAccessType.public : ShareAccessType.private,
        likedUsers: likedUsers,
        resharedUsers: resharedUsers,
        resenderUsers: resenderUsers,
        shareText: shareText,
        shareBookName: shareBookName,
        shareAuthorName: shareAuthorName,
        comments: comments);
  }

  @override
  void write(BinaryWriter writer, SharingModel obj) {
    writer.writeString(obj.userId);
    writer.write(obj.shareTime);
    writer.write(obj.sharingName);
    writer.writeString(obj.shareAccessType.toString());
    writer.writeStringList(obj.likedUsers);
    writer.writeStringList(obj.resharedUsers);
    writer.writeStringList(obj.resenderUsers);
    writer.writeString(obj.shareText);
    writer.writeString(obj.shareBookName ?? "");
    writer.writeString(obj.shareAuthorName ?? "");
    writer.write(obj.comments);
  }
}
