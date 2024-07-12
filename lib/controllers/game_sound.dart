import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class GameSoundController {
  late AudioPlayer? audioPlayer;
  late AudioContext context;
  late AudioPlayer? soundPlayer;
  StreamSubscription? subscription;
  bool isInMenu = false;
  bool _backgroundMusicEnabled = true;
  bool _soundEffectsEnabled = true;

  void setBackgroundMusicEnabled(bool value) => _backgroundMusicEnabled = value;

  void setSoundEffectsEnabled(bool value) => _soundEffectsEnabled = value;

  Future<void> moveEffect() async {
    if (_soundEffectsEnabled) {
      await soundPlayer
          ?.play(AssetSource('682635__bastianhallo__magic-spell.mp3'));
    }
    ;
  }

  Future<void> mergeEffect() async {
    if (_soundEffectsEnabled) {
      await soundPlayer?.play(AssetSource('65733__erdie__bow01.mp3'));
    }
  }

  Future<void> ingameMusic() async {
    if (!_backgroundMusicEnabled) {
      return;
    }
    if (!isInMenu) {
      return;
    }
    isInMenu = false;
    await audioPlayer
        ?.play(AssetSource('Sakura-Girl-Daisy-chosic.com_original.mp3'));
    audioPlayer?.setVolume(0.3);
    subscription = audioPlayer?.onPlayerStateChanged.listen((state) async {
      if (state == PlayerState.completed) {
        await audioPlayer?.seek(Duration.zero);
        await audioPlayer?.resume();
      }
    });
  }

  Future<void> stopBackground() async {
    await audioPlayer?.stop();
    isInMenu = false;
  }

  Future<void> menuMusic() async {
    if (!_backgroundMusicEnabled) {
      return;
    }
    if (isInMenu) {
      return;
    }
    isInMenu = true;
    await audioPlayer?.play(AssetSource('A.Cooper-LastTrack.mp3'));
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
    await menuMusic();
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
