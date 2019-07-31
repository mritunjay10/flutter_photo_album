class Photo {
  String id;
  String photoPath;
  String albumId;
  String uploadedAt;
  String updatedAt;

  Photo(
      {this.id, this.photoPath, this.albumId, this.uploadedAt, this.updatedAt});

  Photo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoPath = json['photo_path'];
    albumId = json['album_id'];
    uploadedAt = json['uploaded_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_path'] = this.photoPath;
    data['album_id'] = this.albumId;
    data['uploaded_at'] = this.uploadedAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}