import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class AudioRecordingService {
  final isPlaying = ValueNotifier<bool>(false);
  final isRecording = ValueNotifier<bool>(false);
  final playbackIsReady = ValueNotifier<bool>(false);

  FutureOr<void> startRecording();
  FutureOr<String> stopRecording();
  FutureOr<void> startPlaying({String? path});
  FutureOr<void> stopPlaying();
  void dispose();
}
