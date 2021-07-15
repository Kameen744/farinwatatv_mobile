class NewsClass {
  final int id;
  final String title;
  final String slug;
  final String detailshome;
  final String detailsread;
  final String catname;
  final String image;
  final String imagemd;
  final String imagesm;
  final String time;
  final String url;

  NewsClass.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'] ?? 0,
        title = jsonMap['title'] ?? '',
        slug = jsonMap['slug'] ?? '',
        detailshome = jsonMap['detailshome'] ?? '',
        detailsread = jsonMap['detailsread'] ?? '',
        catname = jsonMap['catname'] ?? '',
        image = jsonMap['image'] ?? '',
        imagemd = jsonMap['imagemd'] ?? '',
        imagesm = jsonMap['imagesm'] ?? '',
        time = jsonMap['time'] ?? '',
        url = 'https://visionfm.ng/page/news/${jsonMap['slug']}' ?? '';
}
