const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { GoogleGenerativeAI } = require("@google/generative-ai");

admin.initializeApp();
const db = admin.firestore();

// Lấy key trực tiếp từ config an toàn của backend
const API_KEY = process.env.GEMINI_API_KEY || "YOUR_SERVER_API_KEY";
const genAI = new GoogleGenerativeAI(API_KEY);

exports.generateScamScenario = functions.https.onCall(async (data, context) => {
  // 1. KIỂM TRA ĐĂNG NHẬP (Bảo vệ cơ bản)
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'Chỉ user đã đăng nhập mới được dùng API.');
  }

  // 2. CSRF / APP CHECK ENFORCEMENT
  // Đảm bảo request này thực sự được gửi từ App thật, không phải dùng tool (Postman/Curl) gọi lên
  if (context.app == undefined) {
    throw new functions.https.HttpsError('failed-precondition', 'Yêu cầu bị từ chối do App Check thất bại.');
  }

  const uid = context.auth.uid;
  const userRef = db.collection('users').doc(uid);

  // 3. RATE LIMITING (Giới hạn tài nguyên)
  // Check xem lần cuối user gọi là khi nào
  const userDoc = await userRef.get();
  const now = Date.now();
  
  if (userDoc.exists) {
    const lastRequest = userDoc.data().lastAiRequestTime || 0;
    // Giới hạn 10 giây 1 lần request
    if (now - lastRequest < 10000) { 
      throw new functions.https.HttpsError('resource-exhausted', 'Bạn gửi quá nhiều yêu cầu. Vui lòng đợi 10 giây.');
    }
  }

  // Cập nhật lại thời gian gọi API
  await userRef.set({ lastAiRequestTime: now }, { merge: true });

  // 4. THỰC THI GỌI API GEMINI TRÊN BACKEND BẢO MẬT
  try {
    const prompt = data.prompt || "Tạo một kịch bản lừa đảo qua điện thoại";
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });
    
    const result = await model.generateContent(prompt);
    
    // Lưu lịch sử request vào Firestore luôn (dùng cho phần lịch sử màn hình Dashboard)
    await userRef.collection('history').add({
      prompt: prompt,
      response: result.response.text(),
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    });

    return { response: result.response.text() };
  } catch (error) {
    console.error("Gemini API Error:", error);
    throw new functions.https.HttpsError('internal', 'Lỗi khi kết nối với AI Backend.');
  }
});
