// ignore_for_file: public_member_api_docs

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isIOS) {
      return ios;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0bLTJyKEUHL32Wjr_BihoTAouPgff2To',
    appId: '1:673772545165:web:23392822b17d0f14ee2ec4',
    messagingSenderId: '673772545165',
    projectId: 'salonify-f2ef3',
    authDomain: 'salonify-f2ef3.firebaseapp.com',
    storageBucket: 'salonify-f2ef3.firebasestorage.app',
    databaseURL: 'https://salonify-f2ef3-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0bLTJyKEUHL32Wjr_BihoTAouPgff2To',
    appId: '1:673772545165:android:23392822b17d0f14ee2ec4',
    messagingSenderId: '673772545165',
    projectId: 'salonify-f2ef3',
    storageBucket: 'salonify-f2ef3.firebasestorage.app',
    databaseURL: 'https://salonify-f2ef3-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0bLTJyKEUHL32Wjr_BihoTAouPgff2To',
    appId: '1:673772545165:ios:23392822b17d0f14ee2ec4',
    messagingSenderId: '673772545165',
    projectId: 'salonify-f2ef3',
    storageBucket: 'salonify-f2ef3.firebasestorage.app',
    iosClientId: '673772545165-abcdefgh.apps.googleusercontent.com',
    iosBundleId: 'com.example.salonify',
    databaseURL: 'https://salonify-f2ef3-default-rtdb.firebaseio.com',
  );
}
