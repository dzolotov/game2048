import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class GameSoundController {
  late AudioPlayer? audioPlayer;
  late AudioContext context;
  late AudioPlayer? soundPlayer;
  StreamSubscription? subscription;

  Future<void> moveEffect() async {
    await soundPlayer
        ?.play(AssetSource('682635__bastianhallo__magic-spell.mp3'));
  }

  Future<void> mergeEffect() async {
    await soundPlayer?.play(AssetSource('65733__erdie__bow01.mp3'));
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer(playerId: 'music');
    await audioPlayer?.setPlayerMode(PlayerMode.mediaPlayer);
    await audioPlayer?.play(AssetSource('Sakura-Girl-Daisy-chosic.com_.mp3'));
    audioPlayer?.setVolume(0.3);
    subscription = audioPlayer?.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        await audioPlayer?.seek(Duration.zero);
        await audioPlayer?.resume();
      }
    });
    soundPlayer = AudioPlayer(playerId: 'sound');
    soundPlayer?.setVolume(1.0);
    await soundPlayer?.setPlayerMode(PlayerMode.lowLatency);
  }

  Future<void> dispose() async {
    await subscription?.cancel();
    subscription = null;

    await audioPlayer?.stop();
    await audioPlayer?.dispose();
    audioPlayer = null;
    await soundPlayer?.stop();
    await soundPlayer?.dispose();
    soundPlayer = null;
  }
}
