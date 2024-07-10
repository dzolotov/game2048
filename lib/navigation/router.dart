import 'package:game2048/navigation/transition.dart';
import 'package:game2048/screen/hall_of_fame.dart';
import 'package:go_router/go_router.dart';

import '../screen/game.dart';
import '../screen/manual.dart';
import '../screen/start.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const StartScreen(),
      ),
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const GameScreen(),
      ),
    ),
    GoRoute(
      path: '/manual',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const ManualScreen(),
      ),
    ),
    GoRoute(
      path: '/fame',
      pageBuilder: (context, state) => FadeTransitionPage(
        key: state.pageKey,
        child: const HallOfFameScreen(),
      ),
    ),
  ],
);
