import 'dart:io';

import 'package:farinwatatv/classess/video_category.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/classess/video_type.dart';
import 'package:farinwatatv/repositories/channel_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AppModel extends Model {
  AppModel() {
    Future initVideos() async {
      // await getLiveUrl();
      await getVideoTypes();
      await getVideoCategories();
      await getVideoResources();
      // for (int i = 0; i < 9; i++) {
      //   await getVideoResourcesNextPage();
      // }
      await loadCategoryVideos();
    }

    if (this.allVideos == null) {
      initVideos();
    }
  }
//  Pages -------------------------------------------------
  bool portrait = true;
  int selectedPageIndex = 0;
  int previousPageIndex = 0;
  bool loading = true;
  bool livePageFullScreen = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<SliderMenuContainerState> drawerKey =
      GlobalKey<SliderMenuContainerState>();
  bool drawerIsOpen = false;

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
  // void toggleDrawer() {
  //   if (drawerIsOpen) {
  //     drawerKey.currentState.closeDrawer();
  //   } else {
  //     drawerKey.currentState.openDrawer();
  //   }
  //   drawerIsOpen = !drawerIsOpen;
  //   notifyListeners();
  // }

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
  ChannelRepository channelRepository = ChannelRepository();
  List<VideoClass> allVideos;
  List<VideoClass> searchPageVideos;
  List<VideoClass> carouselVideos;
  bool loadingVideos = false;
  List<VideoType> videoTypes;
  List<VideoCategory> vCategories;

  Future getVideoTypes() async {
    List _vidTypes = await channelRepository.getWebResource('videotype');
    videoTypes = _vidTypes.map((type) => VideoType.fromJson(type)).toList();
  }

  Future getVideoCategories() async {
    List _vidCategories =
        await channelRepository.getWebResource('videocategory');
    vCategories =
        _vidCategories.map((cat) => VideoCategory.fromJson(cat)).toList();
  }

  Future getVideoResources() async {
    // if (allVideos == null) {
    allVideos = await channelRepository.getVideos();
    // } else if (allVideos.length < 150) {
    //   await getVideoResourcesNextPage();
    // }
    carouselVideos = allVideos.take(5).toList();
    notifyListeners();
  }

  // Future getVideoResourcesNextPage() async {
  //   List<Video> videos = await channelRepository.getVideos();
  //   allVideos.addAll(videos);
  //   print(allVideos.length);
  //   print('all videos number');
  // }

  Future searchVideo({searchText}) async {
    // if (allVideos == null) {
    //   await getVideoResources();
    // }

    List<VideoClass> searchResult = allVideos
        .where((VideoClass video) =>
            video.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return searchResult;
  }

  Future loadCategoryVideos() async {
    for (int i = 0; i < vCategories.length; i++) {
      List<VideoClass> catVideos =
          await searchVideo(searchText: vCategories[i].searchText);
      vCategories[i].videos = catVideos;
      try {
        vCategories[i].image = catVideos.first.thumbnailUrl;
      } catch (e) {}
      // if (catVideos[0] != null) {}
    }
    notifyListeners();
    if (allVideos.length > 1000) {
      channelRepository.cleanDatabase(allVideos.length - 1000);
    }
    localFile('myFile');
    downloadVideo();
  }

  Future searchedVideosForm({input}) async {
    searchPageVideos = await searchVideo(searchText: input);
    // if (searchPageVideos.length < 1) {
    //   await getVideoResourcesNextPage();
    //   searchPageVideos = await searchVideo(searchText: input);
    // }
    notifyListeners();
  }

  Future loadSearchPageVideos() async {
    return searchPageVideos;
  }

// Files and path

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> localFile(filename) async {
    final path = await _localPath;
    var fil = File('$path/videos/$filename');
    print(fil.path);
  }

  Future<File> writeCounter(int counter) async {
    // final file = await _localFile;

    // Write the file
    // return file.writeAsString('$counter');
  }

  Future<int> readCounter() async {
    // try {
    //   final file = await _localFile;
    //
    //   // Read the file
    //   final contents = await file.readAsString();
    //
    //   return int.parse(contents);
    // } catch (e) {
    //   // If encountering an error, return 0
    //   return 0;
    // }
  }

  Future downloadVideo() {
    var yt = YoutubeExplode();
    var manifest = yt.videos.streamsClient.getManifest('Dpp1sIL1m5Q');
    print(manifest);
    return null;
    // var streamInfo.videoOnly.where((e) => e.container == Container);
    // var streamInfo = streamManifest.muxed.withHigestVideoQuality();
  }
}
