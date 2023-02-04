import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRepo extends StatefulWidget {
  final url;
  final name;
  const WebViewRepo({super.key, this.url, this.name});

  @override
  State<WebViewRepo> createState() => _WebViewRepoState();
}

class _WebViewRepoState extends State<WebViewRepo> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('${widget.name}'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
