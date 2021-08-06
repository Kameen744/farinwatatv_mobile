class VideoCategory {
  int id;
  String title;
  String searchText;
  String type;
  String image;

  // VideoCategory({
  //   this.title,
  //   this.searchText,
  //   this.id,
  //   this.type,
  //   this.image,
  //   this.videos,
  // });
  VideoCategory.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] ?? 0,
        title = jsonMap['title'] ?? '',
        searchText = jsonMap['search'] ?? '',
        type = jsonMap['type'] ?? '',
        image = jsonMap['image'] ?? '';
}
