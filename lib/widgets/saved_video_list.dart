import 'package:cached_network_image/cached_network_image.dart';
import 'package:farinwatatv/classess/time_ago_format.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/pages/play_movie_page.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SavedVideoList extends StatelessWidget {
  final VideoClass video;
  const SavedVideoList({Key key, this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainContext = context;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayMoviePage(
              video: video,
            ),
          ),
        );
      },
      child: ScopedModelDescendant<AppModel>(builder: (child, context, model) {
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
                    image: AssetImage('assets/images/banner.png'),
                  ),
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/images/banner.png'),
                  ),
                ),
              ),
              SizedBox(width: 10),
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
                            video.title.length > 30
                                ? video.title.toUpperCase().substring(0, 25)
                                : video.title.toUpperCase(),
                            style: TextStyle(
                              color: white,
                              fontSize: 11,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.more_vert_rounded),
                          // ),
                          IconButton(
                            onPressed: () {
                              model.deleteSavedVideo(video);
                              showSnackBar(
                                  context: mainContext, message: 'Deleted');
                            },
                            icon: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1, color: red)),
                              child: Center(
                                child: Icon(
                                  Icons.delete,
                                  color: lightGrey,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (model.downloading == video.id)
                      LinearProgressIndicator(
                        color: grey,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void showSnackBar({BuildContext context, String message}) {
    final snackBar = SnackBar(
      backgroundColor: grey,
      content: Text(
        message,
        style: TextStyle(color: black),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
