import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meeting_app/config/error/failure.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Centralized error handler for consistent failure messages
  Failure handleError(String context, dynamic e, [StackTrace? stackTrace]) {
    debugPrint('❌ [$context] Error: $e');
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace, label: '🔍 $context');

    if (e is AuthException) {
      return Failure('Auth error: ${e.message}');
    } else if (e is PostgrestException) {
      return Failure('Database error: ${e.message}');
    } else if (e is StorageException) {
      return Failure('Storage error: ${e.message}');
    } else if (e is SocketException) {
      return Failure('No Internet connection.');
    }

    return Failure('Unexpected error in $context: ${e.toString()}');
  }

  /// ✅ Step 1: Sign up with email/password and store user profile
 Future<Either<Failure, UserModel>> signUp({
  required String email,
  required String password,
  required String name,
  required String phone,
  String? location,
  String? jobTitle,
}) async {
  try {
    // Step 1: Sign up via Supabase Auth
    final res = await _supabase.auth.signUp(
      email: email.trim(),
      password: password.trim(),
    );

    final user = res.user;

    // ✅ If signup fails
    if (user == null) {
      if (res.session == null && res.user == null) {
        return left(Failure("Signup failed: Supabase returned null user/session."));
      } else {
        return left(Failure("Signup failed: Unknown error during signup."));
      }
    }

    final uid = user.id;

  
    // Step 3: Create user model
    final newUser = UserModel(
      userName: name,
      email: email,
      uid: uid,
      phone: phone,
      location: location ?? '',
      jobTitle: jobTitle ?? '',
      profileImage: "awaiting", 
      isOnline: false,
      lastSeen: DateTime.now().toIso8601String(),
    );

    final insertRes = await _supabase.from('users').insert({
      'id': newUser.uid,
      'username': newUser.userName,
      'email': newUser.email,
      'phone': newUser.phone,
      'location': newUser.location,
      'job_title': newUser.jobTitle,
    }).select();

   debugPrint("✅ User inserted: $insertRes");

    return right(newUser);
  } on AuthException catch (e, stack) {
    debugPrint('❌ AuthException: ${e.message}');
    debugPrintStack(stackTrace: stack, label: '[signUp]');
    return left(Failure("Auth error: ${e.message}"));
  } on PostgrestException catch (e, stack) {
    debugPrint('❌ PostgrestException: ${e.message}');
    debugPrintStack(stackTrace: stack, label: '[signUp]');
    return left(Failure("Database insert error: ${e.message}"));
  } catch (e, stack) {
    debugPrint('❌ Unexpected error in signUp: $e');
    debugPrintStack(stackTrace: stack, label: '[signUp]');
    return left(Failure("Unexpected error: ${e.toString()}"));
  }
}


  /// ✅ Step 2: Sign in and fetch user data
  Future<Either<Failure, UserModel>> signIn(String email, String password) async {
    try {
      debugPrint("Signing in with email: $email");
      final res = await _supabase.auth.signInWithPassword(email: email, password: password);
      final user = res.user;

      debugPrint("Sign in result: $user");
      if (user == null) return left(Failure('Login failed.'));

      final data = await _supabase.from('users').select().eq('id', user.id).maybeSingle();
      if (data == null) return left(Failure('User data not found.'));
    
      return right(UserModel.fromJson(data));
    } catch (e, stack) {
      return left(handleError('signIn', e, stack));
    }
  }

  /// ✅ Step 3: Sign out
  Future<Either<Failure,String>> signOut() async {
    await _supabase.auth.signOut();
    return right("Successfully signed out.");
  }

  

  /// ✅ Step 4: Send WhatsApp OTP via Supabase Edge Function
  Future<Either<Failure, String>> sendOtpToWhatsApp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('https://savwcqlrhixilqbryyff.functions.supabase.co/send-whatsapp-otp'),
        headers: {
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhdndjcWxyaGl4aWxxYnJ5eWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxMTA4NDQsImV4cCI6MjA2MjY4Njg0NH0.R_AeeGUFazOsTRT7eR-3SHWCSCxecSM1Os66Gj9i0ag',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phoneNumber}),
      );

      if (response.statusCode == 200) {
        return right("OTP sent successfully.");
      } else {
        return left(Failure("OTP failed: ${response.body}"));
      }
    } catch (e, stack) {
      return left(handleError('sendOtpToWhatsApp', e, stack));
    }
  }

  /// ✅ Step 5: Verify OTP from `phone_verification` table
  Future<Either<Failure, bool>> verifyOtp({
    required String phoneNumber,
    required String inputOtp,
  }) async {
    try {
      final nowUtc = DateTime.now().toUtc().toIso8601String();
      debugPrint("Verifying OTP for $phoneNumber / $inputOtp at $nowUtc");

      final result = await _supabase
          .from('phone_verification')
          .select()
          .eq('phone', phoneNumber)
          .eq('otp', inputOtp)
          .gte('expires_at', nowUtc)
          .order('expires_at', ascending: false)
          .limit(1)
          .maybeSingle();

      debugPrint("OTP result: $result");

      if (result != null) {
        return right(true);
      } else {
        return left(Failure("Invalid or expired OTP."));
      }
    } catch (e, stack) {
      return left(handleError('verifyOtp', e, stack));
    }
  }
}
