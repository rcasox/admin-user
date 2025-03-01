import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class SurveyResultPage extends StatefulWidget {
  final int surveyScore;  // 설문 점수
  final int touchCount;   // Rapid Tapping 테스트 점수
  final int stsTime;      // 5-Times STS 테스트 점수

  SurveyResultPage({
    required this.surveyScore,
    required this.touchCount,
    required this.stsTime,
  });

  @override
  _SurveyResultPageState createState() => _SurveyResultPageState();
}

class _SurveyResultPageState extends State<SurveyResultPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  String _difficulty = "결과 분석 중...";  // 난이도 결과 표시

  @override
  void initState() {
    super.initState();
    _calculateDifficulty();  // 난이도 자동 계산
  }

  // ✅ 운동 난이도를 자동 계산하고 Firebase에 저장하는 함수
  void _calculateDifficulty() async {
    int riskCount = 0;

    // 설문 점수 판단 (4점 이상이면 위험도 증가)
    if (widget.surveyScore >= 4) riskCount++;

    // 터치 횟수 판단 (450 이하이면 위험도 증가)
    if (widget.touchCount <= 450) riskCount++;

    // 5-Times STS 테스트 시간 판단 (12초 이상이면 위험도 증가)
    if (widget.stsTime >= 12) riskCount++;

    // ✅ 최종 난이도 결정
    String difficulty;
    if (riskCount >= 2) {
      difficulty = "하";  // 가장 쉬운 운동 난이도
    } else if (riskCount == 1) {
      difficulty = "중";  // 중간 난이도
    } else {
      difficulty = "상";  // 가장 어려운 운동 난이도
    }

    // ✅ 화면에 표시할 난이도 업데이트
    setState(() {
      _difficulty = difficulty;
    });

    // ✅ Firebase Realtime Database에 난이도 저장
    final user = _auth.currentUser;
    if (user != null) {
      await _database.child("users/${user.uid}").update({
        "difficultyLevel": difficulty,  // 운동 난이도 저장
        "lastUpdated": DateTime.now().millisecondsSinceEpoch,  // 난이도 설정 시간 저장
      });
      print("✅ 난이도 자동 저장 완료: $difficulty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("설문 결과")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("운동 난이도: $_difficulty", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text("홈으로 이동"),
            ),
          ],
        ),
      ),
    );
  }
}
