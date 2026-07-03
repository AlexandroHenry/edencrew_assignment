import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/market/presentation/widgets/market_ranking_detail_app_builder.dart';
import 'features/my/presentation/providers/app_theme_mode_controller.dart';
import 'features/root/presentation/app_shell.dart';
import 'theme/app_theme.dart';

class SampleApp extends ConsumerWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      key: ValueKey(themeMode),
      title: '관심종목',
      debugShowCheckedModeBanner: false,
      theme: buildNamuhXLightTheme(),
      darkTheme: buildNamuhXDarkTheme(),
      themeMode: themeMode,
      navigatorKey: rootNavigatorKey,
      home: const AppShell(),
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle(context),
          child: marketRankingDetailAppBuilder(context, child),
        );
      },
    );
  }
}
