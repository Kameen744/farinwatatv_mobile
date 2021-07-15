import 'package:farinwatatv/classess/time_ago_format.dart';
import 'package:farinwatatv/classess/video_category.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/pages/video_player.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';

class CategoryDetailPage extends StatelessWidget {
  final VideoCategory category;
  CategoryDetailPage({this.category});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      body: getBody(size: size, context: context),
    );
  }

  Widget getBody({size, context}) {
    return Column(
      children: [
        SafeArea(
          child: Container(
            height: size.height * 0.33,
            width: size.width,
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      image: DecorationImage(
                          image: NetworkImage(category.image),
                          fit: BoxFit.cover)),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: white),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        // IconButton(
                        //     icon: Icon(LineIcons.heart, color: white),
                        //     onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      height: 58,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: lightBlack),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => PlayMoviePage()));
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(width: 1, color: red)),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: lightGrey,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Play',
                                    style: TextStyle(
                                        color: lightGrey, fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => VideoPlayer(),
                                //     ),
                                // );
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(width: 1, color: red)),
                                    child: Center(
                                      child: Icon(
                                        Icons.ios_share,
                                        color: lightGrey,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        color: lightGrey, fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              for (VideoClass video in category.videos)
                _buildVideos(video, context),
              SizedBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }

  _buildVideos(VideoClass video, context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(
              video: video,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: EdgeInsets.all(10.0),
        height: 110.0,
        decoration: BoxDecoration(
          color: black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: grey,
              offset: Offset(0, 0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 150.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(video.thumbnailUrl)),
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                // color: Colors.redAccent,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title.length > 35
                              ? video.title.toUpperCase().substring(0, 35)
                              : video.title.toUpperCase(),
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontFamily: 'Source Sans Pro',
                          ),
                        ),
                        Text(
                          TimeAgoFormat.formatDate(date: video.publishedAt),
                          style: TextStyle(
                            color: white,
                            fontSize: 14,
                            fontFamily: 'Source Sans Pro',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      TimeAgoFormat.format(date: video.publishedAt),
                      style: TextStyle(
                        color: white,
                        fontSize: 12,
                        fontFamily: 'Source Sans Pro',
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
