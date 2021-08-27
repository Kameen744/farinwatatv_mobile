import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/pages/favourites_page.dart';
import 'package:farinwatatv/pages/search_page.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/drawer_menu.dart';
import 'package:farinwatatv/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:responsive_navigation_bar/responsive_navigation_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import 'download_page.dart';
import 'home_page.dart';
import 'live_page.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 0;
  List pages = [
    HomePage(),
    SearchPage(),
    LivePage(),
    DownloadPage(),
    FavouritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Scaffold(
        key: model.scaffoldKey,
        drawer: SafeArea(
          child: Container(
            width: 250,
            child: Drawer(
              child: DrawerMenu(),
            ),
          ),
        ),
        body: getBody(model),
        backgroundColor: black,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: getFloatingActionButton(model),
      );
    });
  }

  Widget getAppBar({AppModel model}) {
    switch (model.selectedPageIndex) {
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 20),
            Expanded(
              child: SearchField(),
            ),
          ],
        );
      case 2:
        break;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Farinwata TV',
                style: TextStyle(
                  color: white,
                  fontFamily: 'Bad Script',
                  fontSize: 24.0,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(LineIcons.search),
                color: white,
                onPressed: () {
                  model.selectPage(pageIndex: 1);
                },
              ),
            ),
          ],
        );
        break;
    }
  }

  Widget getBody(AppModel model) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      reverseDuration: Duration(seconds: 2),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: pages[model.selectedPageIndex],
      ),
    );
  }

  Widget getFloatingActionButton(AppModel model) {
    if (model.portrait) {
      if (model.selectedPageIndex == 2) {
        return SizedBox();
      }
      return NavigationBar(
        selectedIndex: model.selectedPageIndex,
        showActiveButtonText: false,
        textStyle: TextStyle(color: white, fontWeight: FontWeight.bold),
        navigationBarButtons: [
          NavigationBarButton(
            icon: LineIcons.home,
            backgroundColor: black,
          ),
          NavigationBarButton(
            icon: LineIcons.search,
            backgroundColor: black,
          ),
          NavigationBarButton(
            icon: LineIcons.youtube,
            backgroundColor: black,
          ),
          NavigationBarButton(
            icon: LineIcons.download,
            backgroundColor: black,
          ),
          NavigationBarButton(
            icon: LineIcons.heart,
            backgroundColor: black,
          ),
        ],
        onTabChange: (index) {
          model.selectPage(pageIndex: index);
        },
      );
    } else {
      return SizedBox();
    }
  }
}
