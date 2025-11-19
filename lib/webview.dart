import 'package:app/My_Web_View.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class Webview extends StatefulWidget {
  const Webview({super.key});

  @override
  State<Webview> createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://sw1-monitoreo.onrender.com/receptor.html'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web View"),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoBack()) {
                    await controller.goBack();
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text("No Back History Found")),
                    );
                    return;
                  }
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              IconButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoForward()) {
                    await controller.goForward();
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text("No Foward History Found")),
                    );
                    return;
                  }
                },
                icon: Icon(Icons.arrow_forward_ios),
              ),
              IconButton(
                onPressed: () {
                  controller.reload();
                },
                icon: Icon(Icons.replay),
              ),
            ],
          ),
        ],
      ),
      body: MyWebView(controller: controller),
    );
  }
}
