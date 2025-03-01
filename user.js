import { db, auth } from "./firebase.js";
import { collection, addDoc, serverTimestamp } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-firestore.js";
import { onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/9.6.1/firebase-auth.js";

document.addEventListener("DOMContentLoaded", function () {
    const questionInput = document.getElementById("questionInput");
    const submitButton = document.getElementById("submitQuestion");
    const currentUserDisplay = document.getElementById("currentUser");
    const logoutButton = document.getElementById("logoutButton");

    let currentUserId = null; // 현재 로그인한 사용자 ID 저장

    // Firebase 인증 상태 확인
    onAuthStateChanged(auth, (user) => {
        if (user) {
            currentUserId = user.uid; // 로그인한 사용자의 UID 사용
            currentUserDisplay.textContent = user.email || user.uid;
        } else {
            currentUserDisplay.textContent = "로그인 필요";
            currentUserId = null;
        }
    });

    // 질문 등록 버튼 클릭 이벤트
    submitButton.addEventListener("click", async function () {
        if (!currentUserId) {
            alert("로그인이 필요합니다.");
            return;
        }

        const question = questionInput.value.trim();

        if (question === "") {
            alert("질문을 입력하세요.");
            return;
        }

        try {
            await addDoc(collection(db, "questions"), {
                userId: currentUserId,
                question: question,
                answer: "",  // 답변은 초기값으로 빈 값 설정
                timestamp: serverTimestamp()
            });

            alert("질문이 등록되었습니다!");
            questionInput.value = "";
        } catch (error) {
            console.error("질문 등록 오류:", error);
            alert("질문 등록에 실패했습니다.");
        }
    });

    // 로그아웃 버튼
    logoutButton.addEventListener("click", () => {
        signOut(auth)
            .then(() => {
                alert("로그아웃되었습니다.");
                location.reload(); // 페이지 새로고침
            })
            .catch((error) => {
                console.error("로그아웃 오류:", error);
                alert("로그아웃에 실패했습니다.");
            });
    });
});
