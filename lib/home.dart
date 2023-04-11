import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  //here goes the webpage URL
  final URL = "https://www.xataka.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(title: const Text('Flutter Simple Example')),
        body: WebView(
            initialUrl: URL,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            }));
  }
}
