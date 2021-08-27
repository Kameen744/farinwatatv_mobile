import 'package:farinwatatv/classess/video_category.dart';
import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/progress_indicator.dart';
import 'package:farinwatatv/widgets/video_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

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
          child: Stack(
            children: [
              Container(
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(category.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: Container(
                    height: 30,
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: lightBlack,
                    ),
                    child: Center(
                      child: ScopedModelDescendant<AppModel>(
                          builder: (child, context, model) {
                        return Text(
                          '${category.title.toUpperCase()} -${model.categoryEpisodes}- Episodes',
                          style: TextStyle(
                              letterSpacing: 2.2,
                              fontSize: 12,
                              fontFamily: 'Source Sans Pro',
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ScopedModelDescendant<AppModel>(builder: (
            child,
            context,
            model,
          ) {
            return FutureBuilder(
                future: model.searchVideo(searchText: category.searchText),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    return ListView(
                      children: [
                        for (VideoClass video in snapShot.data)
                          VideoList(video: video),
                        SizedBox(height: 60),
                      ],
                    );
                  } else {
                    return Progress.indicator();
                  }
                });
          }),
        ),
      ],
    );
  }
}
