import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class ChannelRepository {
  String _mainUrl = 'https://www.googleapis.com/youtube/v3';
  String _webUrl = 'https://farinwatatv.ng/api/v1';
  String _channelId = 'UCm6XLjzqlQyA95wQiRlNinA';
  String _apiKey = 'AIzaSyBnzHFmE5udy7Zt-sTexQkV54dBZGyoAPM';
  String _apiKeyTwo = 'AIzaSyBu5vMApyQbxTJhB5oEcObvTemCENQfz4k';
  String nexPageToken;
  Database database;

  Dio _dio = Dio();
  ChannelRepository({@required this.database});

  _getUrl({pageToken, api}) {
    if (api != null) {
      _apiKey = api;
    }

    if (pageToken != null) {
      return '$_mainUrl/search?part=snippet&channelId=$_channelId&pageToken=$pageToken&maxResults=50&order=date&type=video&key=$_apiKey';
    }

    return '$_mainUrl/search?part=snippet&channelId=$_channelId&maxResults=50&order=date&type=video&key=$_apiKey';
  }

  void setNextPage(next) async {
    await database
        .rawQuery('INSERT OR IGNORE INTO next_page (page) VALUES(?)', [next]);
  }

  Future _getResource() async {
    var response;

    List dbNextPage = await database
        .rawQuery('SELECT page FROM next_page ORDER BY rId DESC LIMIT 1');

    if (dbNextPage.isNotEmpty) {
      nexPageToken = dbNextPage.first['page'];
    }

    final url = _getUrl(pageToken: nexPageToken, api: null);
    final url2 = _getUrl(pageToken: nexPageToken, api: _apiKeyTwo);

    try {
      response = await _dio.get(url);
      print('url-1 connected................');
    } catch (e) {
      response = await _dio.get(url2);
      print('url-2 connected................');
    }

    if (response.data['nextPageToken'] != null) {
      setNextPage(response.data['nextPageToken']);
    }
    return response.data['items'];
  }

  // Future<List<Map<String, Object>>>
  Future saveToDatabase() async {
    List videos = await _getResource();
    videos.forEach((video) async {
      var vInsert = [
        video['id']['videoId'],
        video['snippet']['title'],
        video['snippet']['thumbnails']['medium']['url'],
        video['snippet']['thumbnails']['high']['url'],
        video['snippet']['channelTitle'],
        video['snippet']['publishedAt']
      ];
      database.rawQuery(
          'INSERT OR IGNORE INTO videos(id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?,?,?,?,?,?)',
          vInsert);

      // var videoCheck = await database.rawQuery(
      //     'SELECT id FROM videos WHERE id = ?', [video['id']['videoId']]);
      // if (videoCheck.isEmpty) {
      //   var vInsert = [
      //     video['id']['videoId'],
      //     video['snippet']['title'],
      //     video['snippet']['thumbnails']['medium']['url'],
      //     video['snippet']['thumbnails']['high']['url'],
      //     video['snippet']['channelTitle'],
      //     video['snippet']['publishedAt']
      //   ];
      //
      //   await database.rawInsert(
      //       'INSERT OR IGNORE INTO videos(id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?,?,?,?,?,?)',
      //       vInsert);
      // }
    });
  }

  Future _types(List types) async {
    if (types.isNotEmpty) {
      return database.transaction((txn) async {
        types.forEach((type) async {
          int typeId = type['id'];
          String typeTitle = type['title'];
          String typeDesc = type['description'];

          // var dbType = await txn
          //     .rawQuery('SELECT id FROM v_type WHERE id = ?', [typeId]);
          // if (dbType.isEmpty) {
          //   await txn.rawQuery(
          //       'INSERT OR IGNORE INTO v_type(id, title, description) VALUES(?, ?, ?)',
          //       [typeId, typeTitle, typeDesc]);
          // }

          await txn.rawQuery(
              'INSERT OR IGNORE INTO v_type(id, title, description) VALUES(?, ?, ?)',
              [typeId, typeTitle, typeDesc]);
        });
      });
    }
  }

  Future _categories(List cats) async {
    if (cats.isNotEmpty) {
      cats.forEach((cat) async {
        int catId = cat['id'];
        var _ins = [
          catId,
          cat['title'],
          cat['search'],
          cat['type'],
          cat['image'],
        ];

        // var dbType = await database
        //     .rawQuery('SELECT id FROM v_category WHERE id = ?', [catId]);
        // if (dbType.isEmpty) {
        //   database.rawQuery(
        //       'INSERT OR IGNORE INTO v_category (id, title, search, type, image) VALUES(?, ?, ?, ?, ?)',
        //       _ins);
        // }
        database.rawQuery(
            'INSERT OR IGNORE INTO v_category (id, title, search, type, image) VALUES(?, ?, ?, ?, ?)',
            _ins);
      });
    }
  }

  Future loadTypes(url) async {
    var response = await _dio.get('$_webUrl/$url');
    _types(response.data);
  }

  Future loadCategories(url) async {
    var response = await _dio.get('$_webUrl/$url');
    _categories(response.data);
  }
  // Future getWebResource(String url) async {
  //   try {
  //     final response = await _dio.get('$_webUrl/$url');
  //     if (url == 'videotype') {
  //       await _types(response.data);
  //     } else {
  //       // int count = Sqflite.firstIntValue(
  //       //     await database.rawQuery('SELECT COUNT(*) FROM v_category'));
  //       // assert(count == 2);
  //       // await _categories(response.data);
  //     }
  //   } on DioError {}
  //   return [];
  // }

  void cleanDatabase(int rows) async {
    database.rawQuery(
        'DELETE FROM videos WHERE id IN (SELECT id FROM videos ORDER BY publishedAt ASC LIMIT $rows)');
  }
}
