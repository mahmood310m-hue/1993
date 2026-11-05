
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _db = Supabase.instance.client;

  // تحويل رقم الهاتف العراقي إلى الصيغة الدولية
  static String normalizePhone(String input) {
    String phone = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.startsWith('00964')) {
      phone = phone.substring(2);
    } else if (phone.startsWith('0')) {
      phone = '964${phone.substring(1)}';
    } else if (phone.startsWith('7')) {
      phone = '964$phone';
    }

    if (!RegExp(r'^9647\d{9}$').hasMatch(phone)) {
      throw const FormatException(
        'يرجى إدخال رقم هاتف عراقي صحيح',
      );
    }

    return '+$phone';
  }

  // إنشاء حساب جديد
  static Future<void> register({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    final response = await _db.auth.signUp(
      phone: normalizePhone(phone),
      password: password,
      data: {
        'full_name': fullName.trim(),
      },
    );

    if (response.session == null) {
      throw Exception(
        'لم يتم تفعيل الجلسة. تأكد من تعطيل تأكيد الهاتف في Supabase.',
      );
    }
  }

  // تسجيل الدخول
  static Future<void> login({
    required String phone,
    required String password,
  }) async {
    await _db.auth.signInWithPassword(
      phone: normalizePhone(phone),
      password: password,
    );
  }

  // تسجيل الخروج
  static Future<void> logout() async {
    await _db.auth.signOut();
  }

  static User? get currentUser => _db.auth.currentUser;
}
