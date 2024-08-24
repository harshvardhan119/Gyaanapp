class Bots {
  String? id;
  String? name;
  String? fileid;
  String? desc;
  String? cover_photo;

  Bots({this.id, this.name, this.fileid, this.desc, this.cover_photo});

  Bots.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileid = json['fileid'];
    desc = json['desc'];
    cover_photo = json['cover_photo'];
  }
}
