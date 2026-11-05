
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // تسجيل مستخدم جديد
  Future<AuthResponse> signUp({
    required String phone,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      phone: phone,
      password: password,
    );
  }

  // تسجيل الدخول
  Future<AuthResponse> signIn({
    required String phone,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      phone: phone,
      password: password,
    );
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // المستخدم الحالي
  User? get currentUser {
    return _supabase.auth.currentUser;
  }

  // التحقق من تسجيل الدخول
  bool get isLoggedIn {
    return currentUser != null;
  }
}
