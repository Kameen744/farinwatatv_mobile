import 'package:carousel_slider/carousel_slider.dart';
import 'package:farinwatatv/classess/time_ago_format.dart';
import 'package:farinwatatv/classess/video_category.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/classess/video_type.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/pages/video_player.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:scoped_model/scoped_model.dart';

import 'category_detail_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Scaffold(
        appBar: PreferredSize(
          child: MyAppBar(model: model),
          preferredSize: size,
        ),
        backgroundColor: black,
        body: getBody(size: size, context: context, model: model),
      );
    });
  }

  Widget getBody({size, @required context, AppModel model}) {
    return ListView(
      children: [
        if (model.carouselVideos != null)
          _getCarouselSlider(model.carouselVideos, context),
        SizedBox(height: 30),
        if (model.videoTypes != null)
          for (VideoType vType in model.videoTypes)
            _getSingleChildScroll(
                size: size, model: model, context: context, vType: vType),
        SizedBox(height: 70),
      ],
    );
  }

  _getCarouselSlider(List<VideoClass> videos, context) {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        viewportFraction: 0.93,
        autoPlay: true,
      ),
      items: [
        for (VideoClass video in videos)
          GestureDetector(
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
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: grey,
                    //     offset: Offset(0, 1),
                    //     blurRadius: 6.0,
                    //   ),
                    // ],
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(video.thumbHigh),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      LineIcons.playCircle,
                      color: white,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      // color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width - 27,
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          width: 150,
                          decoration: BoxDecoration(
                            color: white,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      video.title,
                                      style:
                                          TextStyle(color: white, fontSize: 13),
                                    ),
                                    Text(
                                      TimeAgoFormat.formatDate(
                                          date: video.publishedAt),
                                      style:
                                          TextStyle(color: white, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                TimeAgoFormat.format(date: video.publishedAt),
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  _getSingleChildScroll({size, context, AppModel model, VideoType vType}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, bottom: 5, top: 20),
            child: Row(
              children: [
                SizedBox(width: 5),
                Text(
                  vType.title,
                  style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 15,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: grey,
                  size: 16,
                )
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (VideoCategory category in model.vCategories)
                  if (category.type == vType.title)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryDetailPage(category: category),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 130,
                              width: 230,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: grey,
                                    offset: Offset(0, 0),
                                    blurRadius: 3.0,
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(category.image),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  LineIcons.playCircle,
                                  color: white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 13,
                              child: Container(
                                // width:
                                padding: EdgeInsets.only(
                                  top: 2,
                                  bottom: 2,
                                  left: 5,
                                  right: 7,
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 50, 0.7),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    // bottomRight: Radius.elliptical(10, 10),
                                  ),
                                ),
                                child: Text(
                                  category.title,
                                  style: TextStyle(
                                    fontFamily: 'Source Sans Pro',
                                    letterSpacing: 0.5,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
