import { db } from "./firebase.js";
import { collection, getDocs, doc, updateDoc } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-firestore.js";

document.addEventListener("DOMContentLoaded", async function () {
    const loadingMessage = document.getElementById("loadingMessage");
    const questionContainer = document.getElementById("questionContainer");
    const questionText = document.getElementById("questionText");
    const userId = document.getElementById("userId");
    const answer = document.getElementById("answer");
    const answerInput = document.getElementById("answerInput");
    const submitAnswer = document.getElementById("submitAnswer");

    try {
        // Firestore에서 질문 가져오기
        const querySnapshot = await getDocs(collection(db, "questions"));
        let questionFound = false;

        querySnapshot.forEach((docSnapshot) => {
            if (!questionFound) {
                const data = docSnapshot.data();
                if (!data.answer || data.answer === "") {
                    questionFound = true;
                    questionText.textContent = data.question;
                    userId.textContent = data.userId;
                    answer.textContent = data.answer;
                    submitAnswer.dataset.id = docSnapshot.id;  // 문서 ID 저장
                }
            }
        });

        if (questionFound) {
            loadingMessage.style.display = "none";
            questionContainer.style.display = "block";
        } else {
            loadingMessage.textContent = "등록된 질문이 없습니다.";
        }

        // 답변 저장 이벤트
        submitAnswer.addEventListener("click", async function () {
            const docId = this.dataset.id;
            const answerValue = answerInput.value.trim();

            if (answerValue === "") {
                alert("답변을 입력하세요.");
                return;
            }

            try {
                const docRef = doc(db, "questions", docId);
                await updateDoc(docRef, { answer: answerValue });
                alert("답변이 저장되었습니다.");
                location.reload();
            } catch (error) {
                console.error("답변 저장 오류:", error);
                alert("답변 저장에 실패했습니다.");
            }
        });
    } catch (error) {
        console.error("질문을 불러오는 중 오류 발생:", error);
        loadingMessage.textContent = "질문을 불러오는 중 오류가 발생했습니다.";
    }
});
