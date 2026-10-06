// Stub for web platform — provides no-op types so main.dart compiles on web.
import 'package:flutter/widgets.dart';

class WebViewController {
  void Function(String)? _onPageStarted;
  void Function(int)? _onProgress;
  void Function(String)? _onPageFinished;

  WebViewController setJavaScriptMode(dynamic mode) => this;
  WebViewController setNavigationDelegate(dynamic delegate) => this;
  WebViewController loadRequest(Uri uri) => this;
  void reload() {}
}

// Ignored on web — matches the real WebViewWidget signature enough to compile.
class WebViewWidget extends StatelessWidget {
  final WebViewController controller;
  const WebViewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// Ignored on web
enum JavaScriptMode { unrestricted, disabled }

class NavigationDelegate {
  final void Function(String)? onPageStarted;
  final void Function(int)? onProgress;
  final void Function(String)? onPageFinished;
  const NavigationDelegate({this.onPageStarted, this.onProgress, this.onPageFinished});
}
