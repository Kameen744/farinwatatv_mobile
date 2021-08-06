import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:meedu_player/meedu_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayMoviePage extends StatefulWidget {
  final VideoClass video;
  PlayMoviePage({this.video});
  @override
  _PlayMoviePageState createState() => _PlayMoviePageState();
}

class _PlayMoviePageState extends State<PlayMoviePage> {
  final MeeduPlayerController _meeduPlayerController =
      MeeduPlayerController(colorTheme: red);

  int count = 0;

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _init();
  }

  _init() async {
    // launch the player in fullscreen mode
    await this._meeduPlayerController.launchAsFullscreen(context,
        dataSource: DataSource(
            type: DataSourceType.network, source: widget.video.thumbHigh),
        autoplay: true,
        header: header);
  }

  Widget get header {
    return Container(
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: white,
              ),
              onPressed: () {
                // turn back
                Navigator.of(context).popUntil((route) => count++ >= 2);
              }),
          Expanded(
              child: Text(
            widget.video.title,
            style: TextStyle(color: white),
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    _meeduPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeeduVideoPlayer(
        controller: _meeduPlayerController,
      ),
    );
  }
}
