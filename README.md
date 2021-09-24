# audio_recording_service

Demo project for an audio recording service following the D (DIP) word from SOLID.

## Audio Recording Implementations
### flutter_sound_lite
Link: https://pub.dev/packages/flutter_sound_lite
#### Steps to install it in your own projects:
1 Android\
1.1 In android/app/build.gradle, increase `minSdkVersion` to 21\
1.2 On terminal, type `flutter pub add flutter_sound_lite` and press enter\
1.3 On terminal, type `flutter pub add permission_handler` and press enter\
1.4 In android/app/src/main/AndroidManifest.xml, between `manifest` and `application` tags, put\
`<uses-permission android:name="android.permission.RECORD_AUDIO" />`\
`<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />`\
2 iOS\
Not yet
