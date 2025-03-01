import { initializeApp } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-firestore.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-auth.js";

// Firebase 설정
const firebaseConfig = {
  apiKey: "AIzaSyDyOa-Lc5xdMh62AgKmVKoiOv21qieniuU",  // 🚨 올바른 API 키 입력
  authDomain: "untitled3-424fd.firebaseapp.com",
  projectId: "untitled3-424fd",
  storageBucket: "untitled3-424fd.appspot.com",
  messagingSenderId: "1062676113278",
  appId: "1:1062676113278:web:0ad1338f4107fc7eda352f"
};
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };

