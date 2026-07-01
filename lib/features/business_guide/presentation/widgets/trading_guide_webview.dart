import 'package:flutter/material.dart';
import 'package:sample/theme/app_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingGuideWebView extends StatefulWidget {
  const TradingGuideWebView({super.key});

  @override
  State<TradingGuideWebView> createState() => _TradingGuideWebViewState();
}

class _TradingGuideWebViewState extends State<TradingGuideWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.bg.bg_121212)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://m.stock.naver.com/',
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ],
    );
  }
}
