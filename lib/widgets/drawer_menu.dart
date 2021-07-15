import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Container(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 65,
              child: CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/images/logo.jpg'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                children: [
                  Divider(),
                  sliderItem('Home', Icons.home, model, 0, context),
                  Divider(),
                  sliderItem('Search', Icons.search, model, 1, context),
                  Divider(),
                  sliderItem('Live', Icons.video_library, model, 2, context),
                  Divider(),
                  sliderItem('Likes', Icons.add_link, model, 0, context),
                  Divider(),
                  // sliderItem('Setting', Icons.settings),
                  // sliderItem('LogOut', Icons.arrow_back_ios),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget sliderItem(String title, IconData icons, AppModel model, pageIndex,
          BuildContext context) =>
      ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        title: Text(
          title,
          style: TextStyle(color: white, fontFamily: 'BalsamiqSans_Regular'),
        ),
        leading: Icon(
          icons,
          color: white,
        ),
        onTap: () {
          model.selectPage(pageIndex: pageIndex);
          model.closeDrawer(context);
        },
      );
}
