import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(builder: (context, child, model) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (searchText) {
                model.searchedVideosForm(input: searchText);
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                hintText: 'Enter a search text',
              ),
            ),
            TextButton(
              onPressed: () {
                model.searchedVideosForm(input: searchController.text);
              },
              child: Container(
                child: Icon(
                  LineIcons.search,
                  color: white,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
