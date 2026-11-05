
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  bool isRegister = false;
  bool loading = false;
  bool hidePassword = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      if (isRegister) {
        await AuthService.register(
          fullName: _name.text,
          phone: _phone.text,
          password: _password.text,
        );
      } else {
        await AuthService.login(
          phone: _phone.text,
          password: _password.text,
        );
      }
      // AuthGate سينقل المستخدم تلقائياً بعد تسجيل الدخول.
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF397C91);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F8FA),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 65,
                        color: primary,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'مدرسة كوثر الأهلية المختلطة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isRegister ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                        style: const TextStyle(
                          color: primary,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 25),

                      if (isRegister)
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'الاسم الكامل',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().length < 3
                                  ? 'أدخل الاسم الكامل'
                                  : null,
                        ),

                      if (isRegister)
                        const SizedBox(height: 15),

                      TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'رقم الهاتف العراقي',
                          hintText: '07XXXXXXXXX',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? 'أدخل رقم الهاتف'
                                : null,
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _password,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => hidePassword = !hidePassword,
                            ),
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.length < 8
                                ? 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'
                                : null,
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: loading ? null : submit,
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  isRegister
                                      ? 'إنشاء الحساب'
                                      : 'دخول',
                                  style: const TextStyle(fontSize: 17),
                                ),
                        ),
                      ),

                      TextButton(
                        onPressed: loading
                            ? null
                            : () => setState(
                                  () => isRegister = !isRegister,
                                ),
                        child: Text(
                          isRegister
                              ? 'لديك حساب؟ تسجيل الدخول'
                              : 'ليس لديك حساب؟ إنشاء حساب جديد',
                        ),
                      ),

                      const Text(
                        'التسجيل دون رسائل SMS في النسخة التجريبية',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
