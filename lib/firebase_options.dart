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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyA2EPnfzi_d3P1dXqrPrgiurPRNKxSbA4o',
    appId: '1:385835835489:web:474518541bee9770088a20',
    messagingSenderId: '385835835489',
    projectId: 'all-product-79dcd',
    authDomain: 'all-product-79dcd.firebaseapp.com',
    storageBucket: 'all-product-79dcd.firebasestorage.app',
    measurementId: 'G-ESN3NT3MK3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTApJ_w2J9UCW0Wr7_nuhAd2NSjrJNszk',
    appId: '1:385835835489:android:df6a231fa18822d6088a20',
    messagingSenderId: '385835835489',
    projectId: 'all-product-79dcd',
    storageBucket: 'all-product-79dcd.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDf9dyfeYOCZYCUj6vbEzFJI0f0CedjO84',
    appId: '1:385835835489:ios:587475a87af9f961088a20',
    messagingSenderId: '385835835489',
    projectId: 'all-product-79dcd',
    storageBucket: 'all-product-79dcd.firebasestorage.app',
    iosBundleId: 'com.mehedi.myProduct',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDf9dyfeYOCZYCUj6vbEzFJI0f0CedjO84',
    appId: '1:385835835489:ios:587475a87af9f961088a20',
    messagingSenderId: '385835835489',
    projectId: 'all-product-79dcd',
    storageBucket: 'all-product-79dcd.firebasestorage.app',
    iosBundleId: 'com.mehedi.myProduct',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA2EPnfzi_d3P1dXqrPrgiurPRNKxSbA4o',
    appId: '1:385835835489:web:0e2e7e9387c21a39088a20',
    messagingSenderId: '385835835489',
    projectId: 'all-product-79dcd',
    authDomain: 'all-product-79dcd.firebaseapp.com',
    storageBucket: 'all-product-79dcd.firebasestorage.app',
    measurementId: 'G-RP33Z19CGL',
  );
}
