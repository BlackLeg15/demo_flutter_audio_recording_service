import 'dart:async';

import 'package:flutter/material.dart';

import 'app/core/services/audio_recording/audio_recording_service.dart';
import 'app/core/services/audio_recording/flutter_sound_impl/audio_recording_flutter_sound_impl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(home: MyHomePage(title: 'Flutter Audio Recording Demo'));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final Future<AudioRecordingService> _audioRecordingServiceFuture;
  AudioRecordingService? _audioRecordingService;

  @override
  void initState() {
    super.initState();
    _audioRecordingServiceFuture = AudioRecordingFlutterSoundImpl.getInstance();
  }

  @override
  void dispose() {
    _audioRecordingService?.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FutureBuilder(
                future: _audioRecordingServiceFuture,
                builder: (context, AsyncSnapshot<AudioRecordingService> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  _audioRecordingService = snapshot.data!;
                  final isRecording = _audioRecordingService!.isRecording;
                  return ValueListenableBuilder<bool>(
                    valueListenable: isRecording,
                    builder: (context, isRecording, child) {
                      return ElevatedButton.icon(
                        onPressed: isRecording
                            ? () async {
                                await _audioRecordingService!.stopRecording();
                                _audioRecordingService!.startPlaying();
                              }
                            : () async {
                                await _audioRecordingService!.stopPlaying();
                                _audioRecordingService!.startRecording();
                              },
                        icon: isRecording ? const Icon(Icons.play_arrow) : const Icon(Icons.mic),
                        label: isRecording ? const Text('Toque para executar') : const Text('Toque para gravar'),
                        style: ElevatedButton.styleFrom(primary: isRecording ? Colors.green : Colors.red),
                      );
                    },
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
