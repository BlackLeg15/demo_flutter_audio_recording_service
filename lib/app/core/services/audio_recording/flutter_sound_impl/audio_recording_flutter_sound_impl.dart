import 'dart:async';

import 'package:audio_recording_service/app/core/services/audio_recording/audio_recording_service.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordingFlutterSoundImpl extends AudioRecordingService {
  final _codec = Codec.aacADTS;
  var _mPath = '';
  var basePath = '';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  var playerIsInited = false;
  var recorderIsInited = false;

  AudioRecordingFlutterSoundImpl._();

  static Future<AudioRecordingService> getInstance() async {
    final instance = AudioRecordingFlutterSoundImpl._();
    await instance._mPlayer!.openAudioSession();
    instance.playerIsInited = true;
    await instance._openTheRecorder();
    instance.recorderIsInited = true;
    return instance;
  }

  Future<void> _openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      //throw RecordingPermissionException('Microphone permission not granted');
      //TODO Tratar permissão de microfone não concedida
      playerIsInited = false;
      recorderIsInited = false;
      return;
    }
    await _mRecorder!.openAudioSession();
    recorderIsInited = true;
  }

  @override
  FutureOr<void> startPlaying({String? path}) async {
    final finalPath = path ?? _mPath;
    assert(playerIsInited && playbackIsReady.value && _mRecorder!.isStopped && _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
      fromURI: finalPath,
      codec: _codec,
    )
        .then((value) {
      isPlaying.value = true;
    });
  }

  @override
  FutureOr<void> startRecording() {
    _mPath = 'audio${DateTime.now().millisecondsSinceEpoch}.aac';
    isRecording.value = true;
    return _mRecorder!.startRecorder(
      toFile: _mPath,
      codec: _codec,
    );
  }

  @override
  FutureOr<void> stopPlaying() => _mPlayer!.stopPlayer().then((value) {
        isPlaying.value = false;
      });

  @override
  Future<String> stopRecording() => _mRecorder!.stopRecorder().then((value) {
        isRecording.value = false;
        playbackIsReady.value = true;
        return _mPath;
      });

  @override
  void dispose() {
    _mPlayer!.closeAudioSession();
    _mPlayer = null;
    _mRecorder!.closeAudioSession();
    _mRecorder = null;
  }
}
