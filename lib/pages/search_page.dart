import 'package:farinwatatv/classess/video_class.dart';
import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/app_bar.dart';
import 'package:farinwatatv/widgets/progress_indicator.dart';
import 'package:farinwatatv/widgets/video_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return WillPopScope(
        onWillPop: () {
          Future<bool> _changePage() async {
            model.selectPage(pageIndex: model.previousPageIndex);
            return false;
          }

          return _changePage();
        },
        child: Scaffold(
          backgroundColor: black,
          appBar: PreferredSize(
            child: MyAppBar(model: model),
            preferredSize: size,
          ),
          body: FutureBuilder<dynamic>(
            future: model.loadSearchPageVideos(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  controller: _scrollController,
                  children: [
                    for (VideoClass video in snapshot.data)
                      VideoList(video: video),
                    model.loadingVideos ? Progress.indicator() : SizedBox(),
                    SizedBox(height: 60),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
      );
    });
  }

  // _buildVideos(VideoClass video, context) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => VideoPlayerPage(
  //             video: video,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
  //       padding: EdgeInsets.all(10.0),
  //       height: 110.0,
  //       decoration: BoxDecoration(
  //         color: black,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: grey,
  //             offset: Offset(0, 0),
  //             blurRadius: 3.0,
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 150.0,
  //             decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   fit: BoxFit.cover, image: NetworkImage(video.thumbnailUrl)),
  //               borderRadius: BorderRadius.all(Radius.circular(15.0)),
  //               // color: Colors.redAccent,
  //             ),
  //           ),
  //           SizedBox(width: 10.0),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.stretch,
  //               children: [
  //                 Container(
  //                   child: Text(
  //                     video.title.length > 35
  //                         ? video.title.toUpperCase().substring(0, 35)
  //                         : video.title.toUpperCase(),
  //                     style: TextStyle(
  //                       color: white,
  //                       fontSize: 18,
  //                       fontFamily: 'Source Sans Pro',
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   child: Text(
  //                     TimeAgoFormat.formatDate(date: video.publishedAt),
  //                     style: TextStyle(
  //                       color: white,
  //                       fontSize: 18,
  //                       fontFamily: 'Source Sans Pro',
  //                     ),
  //                   ),
  //                 ),
  //                 Container(
  //                   child: Text(
  //                     TimeAgoFormat.format(date: video.publishedAt),
  //                     style: TextStyle(
  //                       color: white,
  //                       fontSize: 12,
  //                       fontFamily: 'Source Sans Pro',
  //                       letterSpacing: 1.2,
  //                     ),
  //                     textAlign: TextAlign.end,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
