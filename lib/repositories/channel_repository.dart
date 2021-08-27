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

  _getUrl({apiKey}) {
    if (nexPageToken == null) {
      return '$_mainUrl/search?part=snippet&channelId=$_channelId&maxResults=50&order=date&type=video&key=$apiKey';
    } else {
      return '$_mainUrl/search?part=snippet&channelId=$_channelId&pageToken=$nexPageToken&maxResults=50&order=date&type=video&key=$apiKey';
    }
  }

  Future _insertNextPage(next) async {
    await database
        .rawQuery('INSERT OR IGNORE INTO next_page (page) VALUES(?)', [next]);
  }

  Future _nextPageToken() async {
    List dbNextPage =
        await database.rawQuery('SELECT page FROM next_page ORDER BY rId DESC');
    if (dbNextPage.isNotEmpty) {
      nexPageToken = dbNextPage.first['page'];
    }
  }

  Future saveToDatabase({@required firstRequest}) async {
    if (firstRequest == false) {
      await _nextPageToken();
    }

    Response<dynamic> response;

    try {
      String url = await _getUrl(apiKey: _apiKey);
      response = await _dio.get(url);
    } catch (e) {
      String url2 = await _getUrl(apiKey: _apiKeyTwo);
      response = await _dio.get(url2);
    }

    if (response.data['nextPageToken'] != null) {
      await _insertNextPage(response.data['nextPageToken']);
    }
    if (response.data['items'] != null) {
      response.data['items'].forEach((video) async {
        var vInsert = [
          video['id']['videoId'],
          video['snippet']['title'],
          video['snippet']['thumbnails']['medium']['url'],
          video['snippet']['thumbnails']['high']['url'],
          video['snippet']['channelTitle'],
          video['snippet']['publishedAt']
        ];
        await database.rawQuery(
            'INSERT OR IGNORE INTO videos(id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?,?,?,?,?,?)',
            vInsert);
      });
    }

    // videos.forEach((video) async {
    //   var vInsert = [
    //     video['id']['videoId'],
    //     video['snippet']['title'],
    //     video['snippet']['thumbnails']['medium']['url'],
    //     video['snippet']['thumbnails']['high']['url'],
    //     video['snippet']['channelTitle'],
    //     video['snippet']['publishedAt']
    //   ];
    //   try {
    //     await database.rawQuery(
    //         'INSERT OR IGNORE INTO videos(id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?,?,?,?,?,?)',
    //         vInsert);
    //   } catch (e) {}
    // });
  }

  Future _types(List types) async {
    if (types.isNotEmpty) {
      types.forEach((type) async {
        await database.rawQuery(
            'INSERT OR IGNORE INTO v_type(id, title, description) VALUES(?, ?, ?)',
            [type['id'], type['title'], type['description']]);
      });
    }
  }

  Future _categories(List cats) async {
    if (cats.isNotEmpty) {
      cats.forEach((cat) async {
        await database.rawQuery(
            'INSERT OR IGNORE INTO v_category (id, title, search, type, image) VALUES(?, ?, ?, ?, ?)',
            [
              cat['id'],
              cat['title'],
              cat['search'],
              cat['type'],
              cat['image']
            ]);
      });
    }
  }

  Future loadTypes(url) async {
    var response = await _dio.get('$_webUrl/$url');
    await _types(response.data);
  }

  Future loadCategories(url) async {
    var response = await _dio.get('$_webUrl/$url');
    await _categories(response.data);
  }

  void cleanDatabase(int rows) async {
    await database.rawQuery(
        'DELETE FROM videos WHERE id IN (SELECT id FROM videos ORDER BY publishedAt ASC LIMIT $rows)');
  }
}
