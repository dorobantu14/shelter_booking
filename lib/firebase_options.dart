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
    apiKey: 'AIzaSyAF_TmQgdvm6IV2O8R3EhdWLEAi58FevYg',
    appId: '1:427390908951:web:7f007388f4b47b8858fa52',
    messagingSenderId: '427390908951',
    projectId: 'shelter-booking-375a3',
    authDomain: 'shelter-booking-375a3.firebaseapp.com',
    storageBucket: 'shelter-booking-375a3.appspot.com',
    measurementId: 'G-P3HJY6YX3Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAY5O--aoZl7EtXBwxv9EAbfHjc0hs6M60',
    appId: '1:427390908951:android:3ca9d26e6c41021258fa52',
    messagingSenderId: '427390908951',
    projectId: 'shelter-booking-375a3',
    storageBucket: 'shelter-booking-375a3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrX1du55orxRWhT5afG9T-FFMIhZA4gqo',
    appId: '1:427390908951:ios:b62e691d6ea84e2958fa52',
    messagingSenderId: '427390908951',
    projectId: 'shelter-booking-375a3',
    storageBucket: 'shelter-booking-375a3.appspot.com',
    iosBundleId: 'com.example.shelterBooking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBrX1du55orxRWhT5afG9T-FFMIhZA4gqo',
    appId: '1:427390908951:ios:8ebc03fa300d690358fa52',
    messagingSenderId: '427390908951',
    projectId: 'shelter-booking-375a3',
    storageBucket: 'shelter-booking-375a3.appspot.com',
    iosBundleId: 'com.example.shelterBooking.RunnerTests',
  );
}
