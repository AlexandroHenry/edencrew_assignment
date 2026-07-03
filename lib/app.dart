import 'package:flutter/material.dart';

import 'features/market/presentation/widgets/market_ranking_detail_app_builder.dart';
import 'features/root/presentation/app_shell.dart';
import 'theme/app_theme.dart';

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '관심종목',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      navigatorKey: rootNavigatorKey,
      home: const AppShell(),
      builder: marketRankingDetailAppBuilder,
    );
  }
}
