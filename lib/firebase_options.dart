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
    apiKey: 'AIzaSyB6VlljtzFPrSz9pW7hUPCaXwxW5KB5zLU',
    appId: '1:447359617320:web:8ac0dd0ac44759e3af681d',
    messagingSenderId: '447359617320',
    projectId: 'famus-d22d9',
    authDomain: 'famus-d22d9.firebaseapp.com',
    storageBucket: 'famus-d22d9.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1PZYkVEpXTt6RYF0RRrXceCP8H7sIdqU',
    appId: '1:447359617320:android:db96df4f09fe0e1baf681d',
    messagingSenderId: '447359617320',
    projectId: 'famus-d22d9',
    storageBucket: 'famus-d22d9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAd5HKR9uZfyRbWAXFL73ip3DQA8ZveJCI',
    appId: '1:447359617320:ios:eb51ed5aeba44150af681d',
    messagingSenderId: '447359617320',
    projectId: 'famus-d22d9',
    storageBucket: 'famus-d22d9.firebasestorage.app',
    iosClientId: '447359617320-j8ovtnr3rc651scv804amlmi4r097ihm.apps.googleusercontent.com',
    iosBundleId: 'com.example.oru',
  );
}
