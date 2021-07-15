class VideoClass {
  String id;
  String title;
  String thumbnailUrl;
  String thumbHigh;
  String channelTitle;
  String publishedAt;

  // Video.fromJson(Map<String, dynamic> snippet)
  //     : id = snippet['id']['videoId'],
  //       title = snippet['snippet']['title'],
  //       thumbnailUrl = snippet['snippet']['thumbnails']['medium']['url'],
  //       thumbHigh = snippet['snippet']['thumbnails']['high']['url'],
  //       channelTitle = snippet['snippet']['channelTitle'],
  //       publishedAt = snippet['snippet']['publishedAt'];

  VideoClass.fromMap(Map<String, Object> snippet)
      : id = snippet['id'],
        title = snippet['title'],
        thumbnailUrl = snippet['thumbnailUrl'],
        thumbHigh = snippet['thumbHigh'],
        channelTitle = snippet['channelTitle'],
        publishedAt = snippet['publishedAt'];
}
