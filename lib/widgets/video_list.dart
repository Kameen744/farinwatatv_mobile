import 'package:cached_network_image/cached_network_image.dart';
import 'package:farinwatatv/classess/time_ago_format.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/pages/video_player.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share_plus/share_plus.dart';

class VideoList extends StatelessWidget {
  final VideoClass video;
  const VideoList({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            video: video,
          ),
        ),
      );
    }, child: ScopedModelDescendant<AppModel>(builder: (child, context, model) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: video.thumbnailUrl,
                placeholder: (context, url) => Image(
                  image: AssetImage('assets/images/banner.jpg'),
                ),
                errorWidget: (context, url, error) => Image(
                  image: AssetImage('assets/images/banner.jpg'),
                ),
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
                              ? video.title.toUpperCase().substring(0, 25)
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
                            fontSize: 10,
                            fontFamily: 'Source Sans Pro',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Text(
                        TimeAgoFormat.format(date: video.publishedAt),
                        style: TextStyle(
                          color: white,
                          fontSize: 10,
                          fontFamily: 'Source Sans Pro',
                        ),
                        textAlign: TextAlign.end,
                      ),
                      if (model.downloading == null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1.3,
                              ),
                              dropdownColor: Colors.transparent,
                              icon: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1, color: red)),
                                child: Center(
                                  child: Icon(
                                    LineIcons.verticalEllipsis,
                                    color: lightGrey,
                                    size: 18,
                                  ),
                                ),
                              ),
                              // iconSize: 20,
                              // elevation: 16,
                              // style: TextStyle(color: Colors.deepPurple),

                              onChanged: (String newValue) {
                                if (newValue == 'Save') {
                                  model.saveVideoStream(video);
                                } else if (newValue == 'Fav') {
                                  model.addFavourite(video);
                                } else if (newValue == 'Share') {
                                  Share.share(
                                      'https://www.youtube.com/watch?v=${video.id}');
                                }
                              },
                              items: [
                                DropdownMenuItem<String>(
                                  value: 'Save',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Save Offline',
                                          style: TextStyle(color: black),
                                        ),
                                        Icon(
                                          Icons.download,
                                          color: black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Fav',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Add Favourites',
                                          style: TextStyle(color: black),
                                        ),
                                        Icon(
                                          LineIcons.heart,
                                          color: black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DropdownMenuItem<String>(
                                  value: 'Share',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Share',
                                          style: TextStyle(color: black),
                                        ),
                                        Icon(
                                          LineIcons.share,
                                          color: black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )),
                  if (model.downloading == video.id)
                    LinearProgressIndicator(
                      minHeight: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(lightBlack),
                      color: grey,
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }
}
