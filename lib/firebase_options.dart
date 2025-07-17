import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return const FirebaseOptions(
          apiKey: 'AIzaSyDC84jghxBEveko2ygk4hoPi3C7RVe6xmI',
          appId: '1:181953536666:android:9351bdcf8c57590780f523',
          messagingSenderId: '181953536666',
          projectId: 'unetpedia-34c0c',
        );
      case TargetPlatform.iOS:
        return const FirebaseOptions(
          apiKey: 'AIzaSyAbsW9On3_X6_d0WfbbHqAYD-bE__FxSwM',
          appId: '1:181953536666:ios:1d60a2ae5ea8a22080f523',
          messagingSenderId: '181953536666',
          projectId: 'unetpedia-34c0c',
          storageBucket: 'unetpedia-34c0c.firebasestorage.app',
          iosBundleId: 'com.dev735.unetpedia',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
