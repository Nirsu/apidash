import 'dart:io';

import 'package:apidash/utils/file_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

typedef VideoErrorWidgetBuilder = Widget Function(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
);

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    super.key,
    required this.bytes,
  });

  final Uint8List bytes;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  Future<void> _openFileToPlayer() async {
    try {
      final name = getTempFileName();
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$name');
      final file = await tempFile.writeAsBytes(widget.bytes);

      player.open(
        Media(file.path),
        play: false,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _openFileToPlayer();
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
