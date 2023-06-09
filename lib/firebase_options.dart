// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyCAo-hji_-rTRIAbRbxN49gDl3APspe9SE',
    appId: '1:1021323525212:web:a5f2b11bc2b665fc79ba99',
    messagingSenderId: '1021323525212',
    projectId: 'rumutai-6b4ce',
    authDomain: 'rumutai-6b4ce.firebaseapp.com',
    storageBucket: 'rumutai-6b4ce.appspot.com',
    measurementId: 'G-SYNT5WWQP9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCL1GOjSh_zAi-oa0e2jN2uaNortgSmP6A',
    appId: '1:1021323525212:android:9563279672ef161a79ba99',
    messagingSenderId: '1021323525212',
    projectId: 'rumutai-6b4ce',
    storageBucket: 'rumutai-6b4ce.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsoKFkDdNNrOtkWBE9vGMaTMUujjC6K90',
    appId: '1:1021323525212:ios:d518188526b02cf079ba99',
    messagingSenderId: '1021323525212',
    projectId: 'rumutai-6b4ce',
    storageBucket: 'rumutai-6b4ce.appspot.com',
    iosClientId: '1021323525212-s5erocedvg1o9ptk4tp5skf2s668mi2i.apps.googleusercontent.com',
    iosBundleId: 'com.example.rumutaiApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsoKFkDdNNrOtkWBE9vGMaTMUujjC6K90',
    appId: '1:1021323525212:ios:d518188526b02cf079ba99',
    messagingSenderId: '1021323525212',
    projectId: 'rumutai-6b4ce',
    storageBucket: 'rumutai-6b4ce.appspot.com',
    iosClientId: '1021323525212-s5erocedvg1o9ptk4tp5skf2s668mi2i.apps.googleusercontent.com',
    iosBundleId: 'com.example.rumutaiApp',
  );
}
