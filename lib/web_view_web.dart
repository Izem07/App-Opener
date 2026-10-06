// Web platform: Google Apps Script requires auth tied to script.google.com,
// which cannot be proxied. We open it in a new tab instead.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';

Widget buildWebFrame(String url) => _WebLauncher(url: url);

class _WebLauncher extends StatefulWidget {
  final String url;
  const _WebLauncher({required this.url});

  @override
  State<_WebLauncher> createState() => _WebLauncherState();
}

class _WebLauncherState extends State<_WebLauncher> {
  bool _opened = false;

  void _open() {
    html.window.open(widget.url, '_blank');
    setState(() => _opened = true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF2E6F40),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.bolt, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connect',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _opened
                  ? 'Opened in a new tab.\nSwitch to that tab to use the app.'
                  : 'Tap below to open the app.\nSign in with your Google account when prompted.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6F40),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(_opened ? Icons.open_in_new : Icons.bolt, size: 20),
                label: Text(
                  _opened ? 'Open Again' : 'Open Connect',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: _open,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
