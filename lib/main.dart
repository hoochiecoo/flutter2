import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. Добавили импорт для управления шторкой
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  // 2. Обязательная инициализация перед вызовом нативного кода
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Делаем шторку полностью прозрачной
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Прозрачный фон
    statusBarIconBrightness: Brightness.dark, // Темные иконки (время, батарея). Если сайт темный — поставьте Brightness.light
    systemNavigationBarColor: Colors.white, // Цвет нижней панели навигации (где кнопки назад/домой)
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // 4. Включаем режим "от края до края" (Edge to Edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WebViewApp(),
  ));
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  
  final String targetUrl = 'https://bowlmates.club/user/UI/b_logout.html';

  final String customUserAgent = 
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  @override
  void initState() {
    super.initState();
    
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(customUserAgent)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(targetUrl));
  }

  @override
  Widget build(BuildContext context) {
    // 5. Scaffold без SafeArea. WebView занимает 100% экрана, включая область под шторкой.
    return Scaffold(
      backgroundColor: Colors.white, // Цвет фона, пока грузится сайт
      body: WebViewWidget(controller: controller),
    );
  }
}
