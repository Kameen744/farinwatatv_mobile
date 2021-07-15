import 'package:farinwatatv/models/app_model.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Scaffold(
        // body: SliderMenuContainer(
        //   hasAppBar: false,
        //   appBarColor: black,
        //   // drawerIcon: Icon(LineIcons.bars, color: white),
        //   drawerIconColor: white,
        //   key: model.drawerKey,
        //   sliderMenuOpenSize: 200,
        //   title: Container(
        //     width: double.infinity,
        //     child: Center(
        //       child: Text(
        //         'Farinwata TV',
        //         style: TextStyle(
        //           color: white,
        //           fontFamily: 'Bad Script',
        //           fontSize: 24.0,
        //           letterSpacing: 2,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        //   sliderMenu: SafeArea(
        //     child: DrawerMenu(),
        //   ),
        //   sliderMain: Container(
        //     color: white,
        //     child: getBody(model),
        //   ),
        //   trailing: SizedBox(),
        // ),
        key: model.scaffoldKey,
        drawer: SafeArea(
          child: Container(
            width: 200,
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
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          child: child,
          scale: animation,
        );
      },
      child: pages[model.selectedPageIndex],
    );
    // return IndexedStack(
    //   index: model.selectedPageIndex,
    //   children: [
    //     HomePage(),
    //     SearchPage(),
    //     LivePage(),
    //     DownloadPage(),
    //   ],
    // );
  }

  Widget getFloatingActionButton(AppModel model) {
    return !model.portrait
        ? SizedBox()
        : NavigationBar(
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
            ],
            onTabChange: (index) {
              model.selectPage(pageIndex: index);
            },
          );
  }
}
