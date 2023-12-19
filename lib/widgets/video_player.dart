import 'dart:io';

import 'package:apidash/utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

// Example : http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4

typedef VideoErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.bytes,
    required this.errorBuilder,
  });

  final Uint8List bytes;
  final VideoErrorWidgetBuilder errorBuilder;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  Future<String> _convertBytesToFile() async {
    final name = getTempFileName();
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$name');
    final file = await tempFile.writeAsBytes(widget.bytes);
    return file.path;
  }

  Future<void> _onLoad() async {
    final filePath = await _convertBytesToFile();
    player.open(
      Media(filePath),
      play: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _onLoad();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Video(controller: controller);
  }
}
