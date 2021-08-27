import 'dart:async';
import 'dart:io';

import 'package:farinwatatv/classess/video_category.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/classess/video_type.dart';
import 'package:farinwatatv/repositories/channel_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AppModel extends Model {
  bool portrait = true;
  int selectedPageIndex = 0;
  int previousPageIndex = 0;
  bool loading = true;
  bool livePageFullScreen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Database database;
  ChannelRepository channelRepository;

  GlobalKey<SliderMenuContainerState> drawerKey =
      GlobalKey<SliderMenuContainerState>();
  bool drawerIsOpen = false;

  Future initApp() async {
    await createDatabase();
    await loadTypesAndCategories();
    await loadCarouselVideos();
    // await getVideoResources();
    loadCategoryImages();
  }

  void selectPage({int pageIndex}) {
    if (!portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      portrait = !portrait;
    }
    previousPageIndex = selectedPageIndex;
    selectedPageIndex = pageIndex;
    notifyListeners();
  }

  void enableWakeLock(bool state) {
    if (state) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState.openDrawer();
    notifyListeners();
  }

  void closeDrawer(context) {
    Navigator.pop(context);
  }

  void changeOrientation() {
    if (portrait) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    portrait = !portrait;
    notifyListeners();
  }

  //  Videos ------------------------------------------------

  // List<VideoClass> allVideos;
  List<VideoClass> searchPageVideos;
  List<VideoClass> carouselVideos;
  bool loadingVideos = false;
  List<VideoType> videoTypes;
  List<VideoCategory> vCategories;
  String downloading;
  int categoryEpisodes = 0;

  Future mapToVideoClass(List videos) async {
    return videos.map((video) => VideoClass.fromMap(video)).toList();
  }

  Future loadTypesAndCategories() async {
    try {
      await channelRepository.loadTypes('videotype');
      await channelRepository.loadCategories('videocategory');
    } catch (e) {}

    List<Map> _vidTypes =
        await database.rawQuery('SELECT * FROM v_type ORDER BY title ASC');
    videoTypes = _vidTypes.map((type) => VideoType.fromJson(type)).toList();
    // video categories
    List<Map> _vidCat =
        await database.rawQuery('SELECT * FROM v_category ORDER BY title ASC');
    vCategories = _vidCat.map((cat) => VideoCategory.fromJson(cat)).toList();
  }

  Future loadCategoryImages() async {
    for (int i = 0; i < vCategories.length; i++) {
      String src = vCategories[i].searchText;

      List catLs = await database.rawQuery(
          "SELECT thumbnailUrl FROM videos WHERE title LIKE '%$src%' ORDER BY publishedAt DESC LIMIT 1");

      if (catLs.isNotEmpty) {
        vCategories[i].image = catLs.first['thumbnailUrl'];
        notifyListeners();
      }
    }
  }

  Future totalRecords() async {
    List ttRecords =
        await database.rawQuery('SELECT COUNT(*) as total FROM videos');
    return ttRecords.first['total'];
  }

  Future loadCarouselVideos() async {
    try {
      await channelRepository.saveToDatabase(firstRequest: true);
      int records = await totalRecords();

      if (records < 521) {
        await channelRepository.saveToDatabase(firstRequest: false);
        await channelRepository.saveToDatabase(firstRequest: false);
      } else if (records > 10000) {
        channelRepository.cleanDatabase(records - 10000);
      }
    } catch (e) {}

    List search = await database
        .rawQuery("SELECT * FROM videos ORDER BY publishedAt DESC LIMIT 6");
    carouselVideos = await mapToVideoClass(search);
  }

  Future searchVideo({searchText}) async {
    List search = await database.rawQuery(
        "SELECT * FROM videos WHERE title LIKE '%$searchText%' ORDER BY publishedAt DESC");
    categoryEpisodes = search.length;
    notifyListeners();
    return await mapToVideoClass(search);
  }

  Future searchedVideosForm({input}) async {
    searchPageVideos = await searchVideo(searchText: input);
    notifyListeners();
  }

  Future loadSearchPageVideos() async {
    return searchPageVideos;
  }

  Future<String> getDocPath() async {
    Directory directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory();
    return directory.path;
  }

  Future saveVideoStream(VideoClass video) async {
    String path = await getDocPath();
    var videoFile = '$path/${video.id}.fvid';
    if (await File(videoFile).exists()) {
    } else {
      YoutubeExplode yt = YoutubeExplode();
      File vFile = new File(videoFile);
      downloading = video.id;
      notifyListeners();

      StreamManifest manifest =
          await yt.videos.streamsClient.getManifest(video.id);
      StreamInfo streamInfo = manifest.muxed.first;
      Stream stream = yt.videos.streamsClient.get(streamInfo);

      try {
        var fileStream = vFile.openWrite();
        await stream.pipe(fileStream).whenComplete(() {
          downloading = null;
          notifyListeners();
        });
        await fileStream.flush();
        await fileStream.close();
      } catch (e) {
        downloading = null;
        notifyListeners();
      }

      database.rawQuery(
          'INSERT OR IGNORE INTO saved_v (id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?, ?, ?, ?, ?, ?)',
          [
            video.id,
            video.title,
            video.thumbnailUrl,
            videoFile,
            'saved',
            video.publishedAt
          ]);
    }
  }

  Future addFavourite(VideoClass video) async {
    database.rawQuery(
        'INSERT OR IGNORE INTO saved_v (id, title, thumbnailUrl, thumbHigh, channelTitle, publishedAt) VALUES(?, ?, ?, ?, ?, ?)',
        [
          video.id,
          video.title,
          video.thumbnailUrl,
          video.thumbHigh,
          'fav',
          video.publishedAt
        ]);
  }

  Future createDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      var path = join(databasesPath, 'frwTv.db');

      database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        db.execute(
            'CREATE TABLE IF NOT EXISTS videos (rId INTEGER PRIMARY KEY AUTOINCREMENT, id TEXT NOT NULL, title TEXT NOT NULL, thumbnailUrl TEXT NOT NULL, thumbHigh TEXT NOT NULL, channelTitle TEXT NOT NULL, publishedAt TEXT NOT NULL, UNIQUE(id))');
        db.execute(
            'CREATE TABLE IF NOT EXISTS saved_v (rId INTEGER PRIMARY KEY AUTOINCREMENT, id TEXT NOT NULL, title TEXT NOT NULL, thumbnailUrl TEXT NOT NULL, thumbHigh TEXT NOT NULL, channelTitle TEXT NOT NULL, publishedAt TEXT NOT NULL, UNIQUE(id))');
        db.execute(
            'CREATE TABLE IF NOT EXISTS v_type (rId INTEGER PRIMARY KEY AUTOINCREMENT, id INTEGER, title TEXT NOT NULL, description TEXT NOT NULL, UNIQUE(title))');
        db.execute(
            'CREATE TABLE IF NOT EXISTS v_category (rId INTEGER PRIMARY KEY AUTOINCREMENT, id INTEGER, title TEXT NOT NULL, search TEXT NOT NULL, type TEXT NOT NULL, image TEXT NOT NULL, UNIQUE(title))');
        db.execute(
            'CREATE TABLE IF NOT EXISTS next_page (rId INTEGER PRIMARY KEY AUTOINCREMENT, page TEXT NOT NULL, UNIQUE(page))');
      });
    } catch (e) {}
    channelRepository = ChannelRepository(database: database);
  }

  Future getSavedVideos() async {
    var sVid = await database.rawQuery(
        'SELECT * FROM saved_v WHERE channelTitle = ? ORDER BY publishedAt DESC',
        ['saved']);
    return await mapToVideoClass(sVid);
  }

  Future getFavVideos() async {
    var fVid = await database.rawQuery(
        'SELECT * FROM saved_v WHERE channelTitle = ? ORDER BY publishedAt DESC',
        ['fav']);
    return await mapToVideoClass(fVid);
  }

  Future deleteSavedVideo(VideoClass video) async {
    String path = await getDocPath();
    var videoFile = '$path/${video.id}.fvid';
    try {
      File vFile = File(videoFile);
      await vFile.delete();
      deleteFavVideo(video);
    } catch (e) {
      deleteFavVideo(video);
    }
  }

  Future deleteFavVideo(VideoClass video) async {
    await database.rawQuery('DELETE FROM saved_v WHERE id = ?', [video.id]);
    notifyListeners();
  }
}
