import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/app_bar.dart';
import 'package:farinwatatv/widgets/progress_indicator.dart';
import 'package:farinwatatv/widgets/saved_video_list.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FavouritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScopedModelDescendant<AppModel>(builder: (child, context, model) {
      return Scaffold(
        backgroundColor: black,
        appBar: PreferredSize(
          child: MyAppBar(model: model),
          preferredSize: size,
        ),
        body: SafeArea(
          child: ScopedModelDescendant<AppModel>(
            builder: (child, context, model) {
              return Container(
                child: FutureBuilder(
                    future: model.getFavVideos(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return SavedVideoList(video: snapshot.data[index]);
                          },
                        );
                      } else {
                        return Progress.indicator();
                      }
                    }),
              );
            },
          ),
        ),
      );
    });
  }
}
