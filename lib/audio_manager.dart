import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  Future<void> init() async {
    // Optionally set volume or other properties
    _backgroundPlayer.setVolume(0.5);
    _sfxPlayer.setVolume(0.7);
  }

  Future<void> playBackgroundMusic(String audioPath) async {
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.play(AssetSource(audioPath));
  }

  Future<void> playSfx(String audioPath) async {
    await _sfxPlayer.play(AssetSource(audioPath));
  }

  void stopBackgroundMusic() {
    _backgroundPlayer.stop();
  }

  void dispose() {
    _backgroundPlayer.dispose();
    _sfxPlayer.dispose();
  }
}