class VideoType {
  int id;
  String title;
  String description;

  // VideoType({
  //   this.title,
  //   this.description,
  //   this.id,
  // });
  VideoType.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] ?? 0,
        title = jsonMap['title'] ?? '',
        description = jsonMap['description'] ?? '';
}
