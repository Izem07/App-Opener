// Web platform: Google Apps Script blocks iframes (X-Frame-Options: SAMEORIGIN).
// Instead, show a launch button that opens the URL in a new tab.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

Widget buildWebFrame(String url) {
  return _WebLauncher(url: url);
}

class _WebLauncher extends StatelessWidget {
  final String url;
  const _WebLauncher({required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.open_in_browser, size: 56, color: Color(0xFF4E9F63)),
          const SizedBox(height: 20),
          const Text(
            'Google Apps Script cannot load\ninside an embedded frame.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E6F40),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            icon: const Icon(Icons.bolt),
            label: const Text(
              'Open Connect',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () => html.window.open(url, '_blank'),
          ),
          const SizedBox(height: 12),
          Text(
            url,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
