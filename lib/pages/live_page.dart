import 'dart:async';

import 'package:farinwatatv/models/app_model.dart';
import 'package:farinwatatv/theme/color.dart';
import 'package:farinwatatv/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:scoped_model/scoped_model.dart';

class LivePage extends StatefulWidget {
  // final AppModel model;
  // LivePage({Key key, this.model}) : super(key: key);

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final GlobalKey webViewKey = GlobalKey();
  final mainUrl =
      "https://player.twitch.tv/?channel=farinwatatv&enableExtensions=true&parent=twitch.tv&player=popout&volume=1";

  InAppWebViewController webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      // mediaPlaybackRequiresUserGesture: false,
      // preferredContentMode: UserPreferredContentMode.MOBILE,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  PullToRefreshController pullToRefreshController;

  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

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
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.red,
                        child: InAppWebView(
                          key: webViewKey,
                          initialUrlRequest: URLRequest(
                            url: Uri.parse(
                                "https://player.twitch.tv/?channel=farinwatatv&enableExtensions=true&parent=twitch.tv&player=popout&volume=1"),
                          ),
                          pullToRefreshController: pullToRefreshController,
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                            model.enableWakeLock(true);
                          },
                          onLoadStart: (controller, url) {
                            if (url.toString() == mainUrl) {
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            } else {
                              controller.stopLoading();
                              controller.goBack();
                            }
                          },
                        ),
                      ),
                      // Positioned(
                      //   top: 10,
                      //   left: 5,
                      //   child: Container(
                      //     color: Colors.transparent,
                      //     width: 150,
                      //     height: 120,
                      //   ),
                      // ),
                      // Positioned(
                      //   bottom: 12,
                      //   right: 110,
                      //   child: Container(
                      //     color: Colors.transparent,
                      //     width: 30,
                      //     height: 25,
                      //   ),
                      // ),
                      // Positioned(
                      //   bottom: 12,
                      //   right: 10,
                      //   child: Container(
                      //     color: Colors.red,
                      //     width: 65,
                      //     height: 25,
                      //     child: Center(
                      //       child: Text(
                      //         'Live',
                      //         style: TextStyle(color: white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                model.portrait ? SizedBox(height: 60) : SizedBox(),
              ],
            ),
          ),
        ),
      );
    });
  }
  // https://player.twitch.tv/?channel=farinwatatv&enableExtensions=true&muted=false&parent=twitch.tv&player=popout&volume=1

  overrideRequest(InAppWebViewController controller,
      shouldOverrideUrlLoadingRequest) async {
    var url = shouldOverrideUrlLoadingRequest.url;
    var uri = Uri.parse(url);

    if ((uri.toString()).startsWith('https://google.com')) {
      controller.goBack();
    } else {
      controller.goBack();
    }
  }
}
