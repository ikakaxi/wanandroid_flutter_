import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebPage extends StatelessWidget {

  String loadUrl = "";
  String title = "";

  WebPage({@required this.loadUrl, this.title}):super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WebviewScaffold(
      url: loadUrl,
      appBar: new AppBar(
        title: new Text(title),
      ),
    );
  }
}