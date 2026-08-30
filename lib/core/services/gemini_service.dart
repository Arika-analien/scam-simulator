import 'package:cloud_functions/cloud_functions.dart';

class GeminiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Gọi API tới backend thay vì gọi trực tiếp tới Gemini
  /// Mọi API Key sẽ được giữ bí mật tuyệt đối trên server.
  Future<String?> generateScamScenario(String prompt) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('generateScamScenario');
      
      // Gọi lên Firebase Functions
      final result = await callable.call({'prompt': prompt});
      
      return result.data['response'] as String?;
    } on FirebaseFunctionsException catch (e) {
      print('Security/Functions Error: ${e.code} - ${e.message}');
      return 'Lỗi hệ thống: ${e.message}';
    } catch (e) {
      print('Unknown Error: $e');
      return 'Xin lỗi, không thể kết nối ngay lúc này.';
    }
  }
}
