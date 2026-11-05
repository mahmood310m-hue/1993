
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static SupabaseClient get _supabase =>
      Supabase.instance.client;

  // تسجيل مستخدم جديد
  static Future<AuthResponse> register({
    required String phone,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      phone: phone,
      password: password,
    );
  }

  // تسجيل الدخول
  static Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      phone: phone,
      password: password,
    );
  }

  // الدوال القديمة للمحافظة على التوافق
  static Future<AuthResponse> signUp({
    required String phone,
    required String password,
  }) async {
    return register(
      phone: phone,
      password: password,
    );
  }

  static Future<AuthResponse> signIn({
    required String phone,
    required String password,
  }) async {
    return login(
      phone: phone,
      password: password,
    );
  }

  // تسجيل الخروج
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // المستخدم الحالي
  static User? get currentUser {
    return _supabase.auth.currentUser;
  }

  // التحقق من تسجيل الدخول
  static bool get isLoggedIn {
    return currentUser != null;
  }
}
