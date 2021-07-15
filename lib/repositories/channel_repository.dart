import 'package:dio/dio.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChannelRepository {
  String _mainUrl = 'https://www.googleapis.com/youtube/v3';
  String _webUrl = 'https://farinwatatv.ng/api/v1';
  String _channelId = 'UCm6XLjzqlQyA95wQiRlNinA';
  // farinwat Gmail = AIzaSyBnzHFmE5udy7Zt-sTexQkV54dBZGyoAPM
  String _apiKey = 'AIzaSyBnzHFmE5udy7Zt-sTexQkV54dBZGyoAPM';
  String _apiKeyTwo = 'AIzaSyBu5vMApyQbxTJhB5oEcObvTemCENQfz4k';
  String nexPageToken;
  String databasePath;
  static int totalResult;
  Dio _dio = Dio();

  _getUrl({pageToken, api}) {
    if (api != null) {
      _apiKey = api;
    }

    if (pageToken != null) {
      return '$_mainUrl/search?part=snippet&channelId=$_channelId&pageToken=$pageToken&maxResults=50&order=date&type=video&key=$_apiKey';
    }
    return '$_mainUrl/search?part=snippet&channelId=$_channelId&maxResults=50&order=date&type=video&key=$_apiKey';
  }

  Future _getResource() async {
    List _videos = [];

    final url = _getUrl(pageToken: nexPageToken, api: null);
    final url2 = _getUrl(pageToken: nexPageToken, api: _apiKeyTwo);

    void setResponseData(response) {
      nexPageToken = response['nextPageToken'];
      totalResult = response['pageInfo']['totalResults'];
      _videos = response['items'];
    }

    try {
      final response = await _dio.get(url);
      setResponseData(response.data);
    } catch (e) {
      final secondReqResponse = await _dio.get(url2);
      setResponseData(secondReqResponse.data);
    }

    return _videos;
  }

  Future<List<Map<String, Object>>> saveToDatabase() async {
    List videos = await _getResource();

    var databasesPath = await getDatabasesPath();
    databasePath = join(databasesPath, 'frwTv.db');

    Database database = await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS videos (id TEXT PRIMARY KEY, title TEXT NOT NULL, thumbnailUrl TEXT NOT NULL, thumbHigh TEXT NOT NULL, channelTitle TEXT NOT NULL, publishedAt TEXT NOT NULL)');
    });

    videos.forEach((video) async {
      var videoCheck = await database.rawQuery(
          'SELECT id FROM videos WHERE id = ?', [video['id']['videoId']]);
      var vInsert = [
        video['id']['videoId'],
        video['snippet']['title'],
        video['snippet']['thumbnails']['medium']['url'],
        video['snippet']['thumbnails']['high']['url'],
        video['snippet']['channelTitle'],
        video['snippet']['publishedAt']
      ];

      if (videoCheck.isEmpty) {
        await database.rawInsert(
            'INSERT INTO videos(id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?,?,?,?,?,?)',
            vInsert);
      }
    });

    return await database
        .rawQuery('SELECT * FROM videos ORDER BY publishedAt DESC');
  }

  Future<List<VideoClass>> getVideos() async {
    List<Map<String, Object>> vids = await saveToDatabase();
    if (vids.length < 400) {
      for (int i = 0; i < 7; i++) {
        vids = await saveToDatabase();
      }
    }
    return vids.map((video) => VideoClass.fromMap(video)).toList();
  }

  Future getWebResource(String url) async {
    try {
      final response = await _dio.get('$_webUrl/$url');
      return response.data;
    } on DioError {
      return [];
    }
  }

  void cleanDatabase(int rows) async {
    Database database = await openDatabase(databasePath);
    database.rawQuery(
        'DELETE FROM videos WHERE id IN (SELECT id FROM videos ORDER BY publishedAt ASC LIMIT $rows)');
  }
}
