import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class GameSoundController {
  late AudioPlayer? audioPlayer;
  late AudioContext context;
  late AudioPlayer? soundPlayer;
  StreamSubscription? subscription;
  bool isBackground = false;

  Future<void> moveEffect() async => await soundPlayer
      ?.play(AssetSource('682635__bastianhallo__magic-spell.mp3'));

  Future<void> mergeEffect() async =>
      await soundPlayer?.play(AssetSource('65733__erdie__bow01.mp3'));

  Future<void> ingame() async {
    if (!isBackground) {
      return;
    }
    isBackground = false;
    await audioPlayer?.play(AssetSource('Sakura-Girl-Daisy-chosic.com_.mp3'));
    audioPlayer?.setVolume(0.3);
    subscription = audioPlayer?.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        await audioPlayer?.seek(Duration.zero);
        await audioPlayer?.resume();
      }
    });
  }

  Future<void> background() async {
    if (isBackground) {
      return;
    }
    isBackground = true;
    await audioPlayer?.play(AssetSource('A. Cooper - Last Track.mp3'));
    audioPlayer?.setVolume(0.3);
    subscription = audioPlayer?.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        await audioPlayer?.seek(Duration.zero);
        await audioPlayer?.resume();
      }
    });
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer(playerId: 'music');
    await audioPlayer?.setPlayerMode(PlayerMode.mediaPlayer);
    soundPlayer = AudioPlayer(playerId: 'sound');
    soundPlayer?.setVolume(1.0);
    await soundPlayer?.setPlayerMode(PlayerMode.lowLatency);
    await background();
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
