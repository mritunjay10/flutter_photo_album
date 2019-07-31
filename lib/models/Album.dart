import 'package:flutter_photo_album/models/Photo.dart';

class Album{

  String id;
  String userId;
  String albumName;
  String albumCover;
  String createdAt;
  String updatedAt;
  List<Photo> photos;

  Album(
      {this.id,
        this.userId,
        this.albumName,
        this.albumCover,
        this.createdAt,
        this.updatedAt,
        this.photos});

  Album.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    albumName = json['album_name'];
    albumCover = json['album_cover'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['photos'] != null) {
      photos = new List<Photo>();
      json['photos'].forEach((v) {
        photos.add(new Photo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['album_name'] = this.albumName;
    data['album_cover'] = this.albumCover;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.photos != null) {
      data['photos'] = this.photos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}