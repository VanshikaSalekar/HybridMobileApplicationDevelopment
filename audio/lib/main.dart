import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: SimpleExampleApp()));
}

class SimpleExampleApp extends StatefulWidget {
  const SimpleExampleApp({super.key});

  @override
  State<SimpleExampleApp> createState() => _SimpleExampleAppState();
}

class _SimpleExampleAppState extends State<SimpleExampleApp> {
  late final AudioPlayer player;

  @override
  void initState() {
    super.initState();

    // Initialize player
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    // Auto-play the audio after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await player.setSource(AssetSource('iphone.mp3'));
        await player.resume();
      } catch (e) {
        debugPrint("Error loading audio: $e");
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Player')),
      body: Center(child: PlayerWidget(player: player)),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;

  const PlayerWidget({required this.player, super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();

    // Listen to audio player events
    _durationSub = player.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });

    _positionSub = player.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });

    _stateSub = player.onPlayerStateChanged.listen((s) {
      setState(() => _playerState = s);
    });
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              color: color,
              iconSize: 48,
              onPressed: _isPlaying ? null : _play,
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              color: color,
              iconSize: 48,
              onPressed: _isPlaying ? _pause : null,
            ),
            IconButton(
              icon: const Icon(Icons.stop),
              color: color,
              iconSize: 48,
              onPressed: _isPlaying || _isPaused ? _stop : null,
            ),
          ],
        ),
        Slider(
          min: 0,
          max: _duration.inMilliseconds.toDouble(),
          value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
          onChanged: (value) {
            final newPos = Duration(milliseconds: value.toInt());
            player.seek(newPos);
          },
        ),
        Text(
          '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _play() async {
    await player.resume();
  }

  Future<void> _pause() async {
    await player.pause();
  }

  Future<void> _stop() async {
    await player.stop();
  }
}
