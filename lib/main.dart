import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Website',
      theme: ThemeData.dark(),
      home: MyHomePage(
        title: 'TheManhattan.org',
        url: 'https://themanhattan.org/',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.url});

  final String title;
  final String url;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = true;
  WebViewController _controller;
  final Completer<WebViewController> _controllerCompleter =
      Completer<WebViewController>();
  //Make sure this function return Future<bool> otherwise you will get an error
  Future<bool> _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 4);
    return Timer(
      duration,
      () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 1,
        ),
        body: loading == true
            ? Center(
                child: Image.asset(
                  "assets/tmo2.gif",
                  fit: BoxFit.fill,
                ),
              )
            : SafeArea(
                child: WebView(
                  key: UniqueKey(),
                  initialUrl: widget.url,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controllerCompleter.complete(webViewController);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
      ),
    );
  }
}
