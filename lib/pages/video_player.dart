import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final VideoClass video;
  VideoPlayerPage({this.video});
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.video.id,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (child, context, model) {
      return YoutubePlayerBuilder(
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          },
          onEnterFullScreen: () {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.landscapeLeft]);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            onReady: () {
              model.enableWakeLock(true);
            },
          ),
          builder: (context, player) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    widget.video.title.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Source Sans Pro',
                      letterSpacing: 1.2,
                      fontSize: 13.0,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: player,
                  ),
                ],
              ),
            );
          });
    });
  }
}
