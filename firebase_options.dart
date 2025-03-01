import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // 웹 환경 설정
      return const FirebaseOptions(
        apiKey: "AIzaSyDP7Tgy4TPN1NlagV0pxM00i8H1YWjNMVo",
        authDomain: "untitled3-424fd.firebaseapp.com",
        projectId: "untitled3-424fd",
        storageBucket: "untitled3-424fd.appspot.com",
        messagingSenderId: "1062676113278",
        appId: "1:1062676113278:web:0ad1338f4107fc7eda352f",
        measurementId: "G-L3MQW451PS",
      );
    } else {
      // 모바일(Android, iOS) 환경 설정
      return const FirebaseOptions(
        apiKey: "AIzaSyDP7Tgy4TPN1NlagV0pxM00i8H1YWjNMVo",
        authDomain: "untitled3-424fd.firebaseapp.com",
        projectId: "untitled3-424fd",
        storageBucket: "untitled3-424fd.appspot.com",
        messagingSenderId: "1062676113278",
        appId: "1:1062676113278:android:22ad86d95ed2968cda352f",
      );
    }
  }
}
