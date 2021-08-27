import 'package:cached_network_image/cached_network_image.dart';
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
        body: getBody(
          size: size,
          context: context,
          model: model,
        ),
      );
    });
  }

  Widget getBody({size, @required context, AppModel model}) {
    return ListView(
      children: [
        _getCarouselSlider(model, context),
        SizedBox(height: 30),
        if (model.videoTypes != null)
          for (VideoType vType in model.videoTypes)
            _getSingleChildScroll(
              size: size,
              mainContext: context,
              model: model,
              vType: vType,
            ),
        SizedBox(height: 70),
      ],
    );
  }

  _getCarouselSlider(AppModel model, context) {
    return CarouselSlider(
      options: CarouselOptions(
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        viewportFraction: 0.93,
        autoPlay: true,
      ),
      items: [
        if (model.carouselVideos != null)
          for (VideoClass video in model.carouselVideos)
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
                    margin: EdgeInsets.only(top: 15),
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: grey,
                          offset: Offset(0, 0),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: video.thumbnailUrl,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/images/banner.png'),
                        ),
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/images/banner.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
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
                    left: 15,
                    right: 15,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.8),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      width: MediaQuery.of(context).size.width - 50,
                      child: Column(
                        children: [
                          Container(
                            height: 2,
                            width: 100,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title.length > 35
                                            ? video.title
                                                .toUpperCase()
                                                .substring(0, 25)
                                            : video.title.toUpperCase(),
                                        style: TextStyle(
                                            color: white, fontSize: 13),
                                      ),
                                      Text(
                                        TimeAgoFormat.formatDate(
                                            date: video.publishedAt),
                                        style: TextStyle(
                                            color: white, fontSize: 10),
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

  _getSingleChildScroll({size, mainContext, AppModel model, VideoType vType}) {
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
                    fontSize: 17,
                    letterSpacing: 2.0,
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
                if (model.vCategories != null)
                  for (VideoCategory category in model.vCategories)
                    if (category.type == vType.title)
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.push(
                              mainContext,
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: grey,
                                      offset: Offset(0, 0),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: category.image,
                                    placeholder: (context, url) => Image(
                                      image: AssetImage(
                                          'assets/images/banner.png'),
                                    ),
                                    errorWidget: (context, url, error) => Image(
                                      image: AssetImage(
                                          'assets/images/banner.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    LineIcons.list,
                                    color: white,
                                    size: 12,
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
                                    color: black,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: grey,
                                        offset: Offset(0.2, 0),
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    category.title,
                                    style: TextStyle(
                                      fontFamily: 'Source Sans Pro',
                                      letterSpacing: 1.2,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
