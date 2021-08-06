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

  // _buildVideos(VideoClass video, context) {
  //   return GestureDetector(onTap: () {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => VideoPlayerPage(
  //           video: video,
  //         ),
  //       ),
  //     );
  //   }, child: ScopedModelDescendant<AppModel>(builder: (child, context, model) {
  //     return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         video.title.length > 35
  //                             ? video.title.toUpperCase().substring(0, 35)
  //                             : video.title.toUpperCase(),
  //                         style: TextStyle(
  //                           color: white,
  //                           fontSize: 14,
  //                           fontFamily: 'Source Sans Pro',
  //                         ),
  //                       ),
  //                       Text(
  //                         TimeAgoFormat.formatDate(date: video.publishedAt),
  //                         style: TextStyle(
  //                           color: white,
  //                           fontSize: 14,
  //                           fontFamily: 'Source Sans Pro',
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.end,
  //                     children: [
  //                       Text(
  //                         TimeAgoFormat.format(date: video.publishedAt),
  //                         style: TextStyle(
  //                           color: white,
  //                           fontSize: 12,
  //                           fontFamily: 'Source Sans Pro',
  //                           letterSpacing: 1.2,
  //                         ),
  //                         textAlign: TextAlign.end,
  //                       ),
  //                       // IconButton(
  //                       //   onPressed: () {},
  //                       //   icon: Icon(Icons.more_vert_rounded),
  //                       // ),
  //                       ButtonTheme(
  //                         alignedDropdown: true,
  //                         child: DropdownButton<String>(
  //                           icon: const Icon(Icons.arrow_downward),
  //                           // iconSize: 20,
  //                           // elevation: 16,
  //                           // style: TextStyle(color: Colors.deepPurple),
  //                           underline: SizedBox(),
  //                           onChanged: (String newValue) {
  //                             if (newValue == 'Save') {
  //                               model.saveVideoStream(video);
  //                             }
  //                           },
  //                           items: [
  //                             DropdownMenuItem<String>(
  //                               value: 'Save',
  //                               child: Container(
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: 5, horizontal: 10),
  //                                 color: Colors.red,
  //                                 child: Text('Save'),
  //                               ),
  //                             ),
  //                             DropdownMenuItem<String>(
  //                               value: 'Favourite',
  //                               child: Container(
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: 5, horizontal: 10),
  //                                 color: Colors.red,
  //                                 child: Text('fav'),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }));
  // }
}
