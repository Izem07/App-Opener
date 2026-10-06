import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// webview_flutter on mobile; no-op stubs on web so it compiles in Chrome
import 'package:webview_flutter/webview_flutter.dart'
    if (dart.library.html) 'mobile_webview_stub.dart';

// Platform-adaptive content builder: <iframe> on web, WebView on mobile
import 'web_view_stub.dart' if (dart.library.html) 'web_view_web.dart';

void main() {
  runApp(const ConnectApp());
}

// ==========================================
// CONFIG: Easily add or manage your links here
// ==========================================
final List<AppDestination> appDestinations = [
  AppDestination(
    title: 'Connect',
    url:
        'https://script.google.com/macros/s/AKfycbyQrbJTidEmKmnjmxP5GEL-gthU53w30JPHfWYhHnjmhOMFto24GZuIsrdgpcx4HcWLww/exec',
    icon: Icons.bolt,
  ),
  // You can easily add more web links here in the future:
  // AppDestination(
  //   title: 'Portal 2',
  //   url: 'https://your-other-link-here.com',
  //   icon: Icons.link,
  // ),
];

class AppDestination {
  final String title;
  final String url;
  final IconData icon;

  AppDestination({
    required this.title,
    required this.url,
    required this.icon,
  });
}

class ConnectApp extends StatelessWidget {
  const ConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
            const Color(0xFF121814), // Dark deep green tint
        primaryColor: const Color(0xFF2E6F40), // Clean Google/App Green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2E6F40),
          surface: Color(0xFF1B241E),
        ),
      ),
      home: const ConnectWebViewScreen(),
    );
  }
}

class ConnectWebViewScreen extends StatefulWidget {
  const ConnectWebViewScreen({super.key});

  @override
  State<ConnectWebViewScreen> createState() => _ConnectWebViewScreenState();
}

class _ConnectWebViewScreenState extends State<ConnectWebViewScreen> {
  // Mobile-only WebView controller — null on web
  WebViewController? _controller;
  int _currentIndex = 0;
  bool _isLoading = true;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  /// Restore the last active tab from device storage
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    int savedIndex = prefs.getInt('active_index') ?? 0;
    if (savedIndex >= appDestinations.length) savedIndex = 0;

    setState(() => _currentIndex = savedIndex);

    if (!kIsWeb) {
      _initController(appDestinations[_currentIndex].url);
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _initController(String urlString) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onProgress: (p) => setState(() => _progress = p / 100),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(urlString));
  }

  Future<void> _switchDestination(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('active_index', index);
    setState(() => _currentIndex = index);
    if (!kIsWeb) {
      _initController(appDestinations[index].url);
    }
  }

  Widget _buildContent() {
    final url = appDestinations[_currentIndex].url;

    if (kIsWeb) {
      // Web: render the Google Apps Script URL inside an <iframe>
      return buildWebFrame(url);
    }

    // Mobile: native WebView with progress bar
    return Column(
      children: [
        if (_isLoading)
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: const Color(0xFF1B241E),
            color: const Color(0xFF2E6F40),
            minHeight: 2,
          ),
        Expanded(
          child: _controller != null
              ? WebViewWidget(controller: _controller!)
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDestination = appDestinations[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1B241E),
        title: Text(
          currentDestination.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: 'Reload Page',
            onPressed: () {
              if (kIsWeb) {
                setState(() {}); // Rebuilds iframe
              } else {
                _controller?.reload();
              }
            },
          ),
        ],
      ),
      body: _buildContent(),
      // Bottom nav auto-shows when 2+ destinations are configured
      bottomNavigationBar: appDestinations.length > 1
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _switchDestination,
              backgroundColor: const Color(0xFF1B241E),
              selectedItemColor: const Color(0xFF4E9F63),
              unselectedItemColor: Colors.grey,
              items: appDestinations
                  .map((dest) => BottomNavigationBarItem(
                        icon: Icon(dest.icon),
                        label: dest.title,
                      ))
                  .toList(),
            )
          : null,
    );
  }
}
