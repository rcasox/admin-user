import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QnAScreen extends StatefulWidget {
  final bool isAdmin; // 관리자 여부

  QnAScreen({required this.isAdmin});

  @override
  _QnAScreenState createState() => _QnAScreenState();
}

class _QnAScreenState extends State<QnAScreen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isAdmin ? '관리자 - 질문 답변' : '답변 완료된 질문')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .where('answer', isEqualTo: widget.isAdmin ? '' : null) // 관리자: 빈 답변만 / 사용자: 답변 있는 질문만
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var questions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              var questionData = questions[index].data() as Map<String, dynamic>;
              String questionId = questions[index].id;
              String questionText = questionData['question'];
              String answerText = questionData['answer'];

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(questionText),
                  subtitle: widget.isAdmin
                      ? _adminAnswerWidget(questionId, questionText, answerText)
                      : Text('답변: $answerText'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🔹 관리자가 답변 입력하는 UI
  Widget _adminAnswerWidget(String questionId, String questionText, String currentAnswer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('현재 답변: ${currentAnswer.isEmpty ? "없음" : currentAnswer}'),
        SizedBox(height: 5),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(labelText: '답변 입력'),
        ),
        SizedBox(height: 5),
        ElevatedButton(
          onPressed: () async {
            String newAnswer = _answerController.text.trim();
            if (newAnswer.isNotEmpty) {
              await FirebaseFirestore.instance
                  .collection('questions')
                  .doc(questionId)
                  .update({'answer': newAnswer}); // 답변 업데이트
              _answerController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('답변이 저장되었습니다.')));
            }
          },
          child: Text('답변 저장'),
        ),
      ],
    );
  }
}
