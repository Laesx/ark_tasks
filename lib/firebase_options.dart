// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBj_mqRKpvvNOBvVnI3c5ypLSWhttiV63A',
    appId: '1:153485569693:web:1b875be780991c7df1ee74',
    messagingSenderId: '153485569693',
    projectId: 'notestest-a78c0',
    authDomain: 'notestest-a78c0.firebaseapp.com',
    storageBucket: 'notestest-a78c0.appspot.com',
    measurementId: 'G-LD7HT10TJT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOVD_WJ15TMlNNkvOjIHKjs0vzvWUUNmA',
    appId: '1:153485569693:android:f089c82bb1f89edff1ee74',
    messagingSenderId: '153485569693',
    projectId: 'notestest-a78c0',
    storageBucket: 'notestest-a78c0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZG9zSKbsnW7Jvc9yFLFGFHkhh7Jq5DtA',
    appId: '1:153485569693:ios:8d3e5eb9f3de2e7bf1ee74',
    messagingSenderId: '153485569693',
    projectId: 'notestest-a78c0',
    storageBucket: 'notestest-a78c0.appspot.com',
    iosBundleId: 'com.example.arkJots',
  );
}
