import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
            Image(
              width: 150,
              height: 150,
              image: AssetImage('assets/images/logoLight.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Startimes Channel 178 / 470'),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Column(
                  children: [
                    Divider(),
                    sliderItem('Home', Icons.home, model, 0, context),
                    Divider(),
                    sliderItem('Search', Icons.search, model, 1, context),
                    Divider(),
                    sliderItem('Live', Icons.video_library, model, 2, context),
                    Divider(),
                    sliderItem(
                        'Downloads', LineIcons.download, model, 3, context),
                    Divider(),
                    sliderItem(
                        'Favourites', LineIcons.heart, model, 4, context),
                    Divider(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Center(
                            child: Text('Contact'),
                          ),
                          Divider(),
                          Contact(number: '+234-8051101589'),
                          Contact(number: '+234-8069111106'),
                          Contact(number: '+234-8033225331'),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
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

class Contact extends StatelessWidget {
  final String number;
  Contact({Key key, @required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        number,
        style: TextStyle(
          letterSpacing: 3.5,
          fontSize: 12,
        ),
      ),
    );
  }
}
