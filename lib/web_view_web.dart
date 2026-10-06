// Web-only implementation: renders the URL inside an <iframe> via HtmlElementView.
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/widgets.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

Widget buildWebFrame(String url) {
  final String viewId = 'iframe-${url.hashCode}';

  // Register the iframe factory (safe to call multiple times — no-op if already registered)
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) {
    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'fullscreen';
    return iframe;
  });

  return HtmlElementView(viewType: viewId);
}
