import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MyAppBar extends StatelessWidget {
  final AppModel model;
  const MyAppBar({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: appBar(model, context),
    );
  }

  appBar(AppModel model, BuildContext context) {
    switch (model.selectedPageIndex) {
      case 1:
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(LineIcons.arrowLeft),
                  color: white,
                  onPressed: () {
                    model.selectPage(pageIndex: model.previousPageIndex);
                  },
                ),
                Expanded(
                  child: SearchField(),
                ),
              ],
            ),
          ),
        );
        break;

      case 2:
        return SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(LineIcons.arrowLeft),
                color: white,
                onPressed: () {
                  model.selectPage(pageIndex: model.previousPageIndex);
                },
              ),
              Text(
                'Farinwata Live',
                style: TextStyle(
                  color: white,
                  fontFamily: 'Bad Script',
                  fontSize: 20.0,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: model.portrait
                    ? Icon(Icons.screen_lock_landscape)
                    : Icon(Icons.screen_lock_portrait),
                color: white,
                onPressed: () {
                  model.changeOrientation();
                },
              ),
            ],
          ),
        );
        break;

      default:
        return SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: model.drawerIsOpen
                    ? Icon(Icons.close)
                    : Icon(LineIcons.bars),
                color: white,
                onPressed: () {
                  model.openDrawer();
                },
              ),
              Text(
                'Farinwata TV',
                style: TextStyle(
                  color: white,
                  fontFamily: 'Bad Script',
                  fontSize: 20.0,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(LineIcons.search),
                color: white,
                onPressed: () {
                  model.selectPage(pageIndex: 1);
                },
              ),
            ],
          ),
        );
        break;
    }
  }
}
