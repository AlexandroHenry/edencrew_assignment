import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/app_bottom_nav.dart';

final currentAppTabProvider = StateProvider<AppTab>((ref) => AppTab.market);
