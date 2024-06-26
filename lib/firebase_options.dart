// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBBjGyHjJNEre4wqjgcZd2Sk3JTiFAO_kc',
    appId: '1:744836218062:android:723df5b600dc412d2fa49f',
    messagingSenderId: '744836218062',
    projectId: 'financemanagement-ead7b',
    storageBucket: 'financemanagement-ead7b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsoMpZQEa8jjOWXpx0oVTjgnVwfp72eI8',
    appId: '1:744836218062:ios:ae2187274c0be7a62fa49f',
    messagingSenderId: '744836218062',
    projectId: 'financemanagement-ead7b',
    storageBucket: 'financemanagement-ead7b.appspot.com',
    iosBundleId: 'com.example.financemanagement',
  );

}