import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mymusicapp/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  final List<Song> _playlist = [
    Song(
      songName: "Genius",
      artistName: "LSD",
      albumArtImagePath: "assets/images/sia.jpeg",
      audioPath: "audio/Genius.mp3",
    ),
    Song(
      songName: "Houdini",
      artistName: "Eminem",
      albumArtImagePath: "assets/images/EM.jpeg",
      audioPath: "audio/Houdini.mp3",
    ),
    Song(
      songName: "Cake & Iced Coffee",
      artistName: "Leyla Blue",
      albumArtImagePath: "assets/images/LB.jpeg",
      audioPath: "audio/CakeCoffee.mp3",
    ),
    Song(
        songName: "New Rules",
        artistName: "Dua Lipa",
        albumArtImagePath: "assets/images/DP.jpeg",
        audioPath: "audio/New_Rules.mp3")
  ];

  int? _currentSongIndex;

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // play previos song
  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // list to duraion
  void listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  //dispose of audioplayers

//Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  //setters
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
