import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/game_sound.dart';
// import '../interop/web/web_impl.dart';
import '../interop/universal_export.dart';

class HallOfFameEntry extends StatelessWidget {
  final String login;
  final int score;
  final Color color;

  const HallOfFameEntry({
    required this.login,
    required this.score,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [],
    );
  }
}

class HallOfFameScreen extends HookWidget {
  const HallOfFameScreen({super.key});

  static const maxPlayers = 10;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final soundController = context.read<GameSoundController>();
      soundController.menuMusic();
      return null;
    });
    // final fame =
    //     useMemoized(() => globalContext.getProperty('fame'.toJS) as Fame);
    final records = fameRecords; //universal
    records.sort((a, b) => -a.score.compareTo(b.score));
    // final empty = JSObject() as FameEntry;
    // empty.player = '';
    // empty.score = -1;
    final empty = createEmpty();
    empty.player = '';
    empty.score = -1;
    while (records.length < maxPlayers) {
      records.add(empty);
    }
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Hall of fame',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Table(
                children: [
                  for (final (index, data)
                      in records.sublist(0, maxPlayers).indexed) ...[
                    TableRow(
                      decoration: BoxDecoration(
                        color: ColorTween(
                          begin: Colors.pink.shade400,
                          end: Colors.yellowAccent.shade400,
                        ).transform(index / maxPlayers),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.player,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.score > 0 ? data.score.toString() : '-',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const TableRow(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  ],
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.go('/');
                },
                child: const Text('Go to start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
