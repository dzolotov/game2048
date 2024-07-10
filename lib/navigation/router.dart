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
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) => const GameScreen(),
    ),
    GoRoute(
      path: '/manual',
      builder: (context, state) => const ManualScreen(),
    ),
    GoRoute(
        path: '/fame', builder: (context, state) => const HallOfFameScreen()),
  ],
);
