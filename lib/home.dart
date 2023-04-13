import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewWebView extends StatefulWidget {
  const NewWebView({Key? key}) : super(key: key);

  @override
  State<NewWebView> createState() => _NewWebViewState();
}

class _NewWebViewState extends State<NewWebView> {
  late WebViewController webViewController;
  bool _isLoading = false;

  //Since Here: This is to force fullScreen On
  @override
  void initState() {
    super.initState();

    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    // Enable virtual display.
    //changed AndroidWebView() to SurfaceAndroidWebView()
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FullScreen.exitFullScreen();
  }
  //Until here: This is to force fullScreen On

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          WebView(
            gestureNavigationEnabled: true,
            //here goes the URL
            initialUrl: 'https://flutter.dev',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              this.webViewController = webViewController;
            },
            zoomEnabled: false,
            //comment from here to disable pull to refresh
            gestureRecognizers: Set()
              ..add(
                Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                    ..onDown = (DragDownDetails dragDownDetails) {
                      webViewController.getScrollY().then((value) {
                        if (value == 0 &&
                            dragDownDetails.globalPosition.direction < 1) {
                          webViewController.reload();
                          setState(() {
                            _isLoading = true;
                          });
                        }
                      });
                    },
                ),
              ),
            onPageStarted: (String url) {
              /* setState(() {
                _isLoading = true;
              }); */
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            //comment to here to disable pull to refresh
          ),
          //comment from here to disable pull to refresh
          if (_isLoading)
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          //comment to here to disable pull to refresh
        ],
      ),
    );
  }
}
