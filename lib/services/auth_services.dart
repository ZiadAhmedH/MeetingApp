import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meeting_app/config/error/failure.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ✅ Step 1: Sign up with email/password after OTP verified
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? location,
    String? jobTitle,
    String? profileImage,
  }) async {
    try {
      final res = await _supabase.auth.signUp(email: email, password: password);
      final user = res.user;

      if (user != null) {
        final uid = user.id;
        String? uploadedImageUrl;

        if (profileImage != null) {
          uploadedImageUrl = await _uploadProfileImage(profileImage);
        }

        final newUser = UserModel(
          userName: name,
          email: email,
          uid: uid,
          phone: phone,
          location: location ?? '',
          jobTitle: jobTitle ?? '',
          profileImage: uploadedImageUrl,
        );

        try {
          final res = await _supabase.from('users').insert({
            'UserName': newUser.userName,
            'Email': newUser.email,
            'uid': newUser.uid,
            'phone': newUser.phone,
            'Location': newUser.location,
            'JobTitle': newUser.jobTitle,
            'profileImage': newUser.profileImage,
          });
          print("User inserted: $res");
        } catch (e) {
          print("Insert failed: $e");
          return left(Failure("Insert error: $e"));
        }

        return right(newUser);
      } else {
        return left(Failure('Sign up failed. User is null.'));
      }
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error during sign up: $e'));
    }
  }

  // ✅ Step 2: Sign in
  Future<Either<Failure, UserModel>> signIn(
      String email, String password) async {
    try {
      final res = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      final user = res.user;

      if (user != null) {
        final data = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();

        if (data == null) return left(Failure('User data not found.'));

        final userModel = UserModel.fromJason(data);
        return right(userModel);
      } else {
        return left(Failure('Login failed. User is null.'));
      }
    } on AuthException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error during login: $e'));
    }
  }

  // ✅ Step 3: Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ✅ Upload profile image to Supabase Storage
  Future<String?> _uploadProfileImage(String profileImagePath) async {
    try {
      final file = File(profileImagePath);
      final fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadRes =
          await _supabase.storage.from('avatars').upload(fileName, file);

      if (uploadRes.isEmpty) return null;

      final fileUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
      return fileUrl;
    } catch (e) {
      print("Error uploading profile image: $e");
      return null;
    }
  }

  // ✅ Step 4: Send WhatsApp OTP via Edge Function
  Future<Either<Failure, String>> sendOtpToWhatsApp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://savwcqlrhixilqbryyff.functions.supabase.co/send-whatsapp-otp'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhdndjcWxyaGl4aWxxYnJ5eWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcxMTA4NDQsImV4cCI6MjA2MjY4Njg0NH0.R_AeeGUFazOsTRT7eR-3SHWCSCxecSM1Os66Gj9i0ag',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'phone': phoneNumber}),
      );

      if (response.statusCode == 200) {
        return right("OTP sent via WhatsApp successfully.");
      } else {
        print("Failed to send OTP: ${response.body}");
        return left(Failure("Failed to send OTP: ${response.body}"));
      }
    } catch (e) {
      return left(Failure("Unexpected error during OTP send: $e"));
    }
  }

  // ✅ Step 5: Verify OTP from Supabase `phone_verification` table
  Future<Either<Failure, bool>> verifyOtp({
    required String phoneNumber,
    required String inputOtp,
  }) async {
    try {
      final nowUtc = DateTime.now().toUtc().toIso8601String();
      print("Verifying OTP for $phoneNumber / $inputOtp at $nowUtc");

      final result = await _supabase
          .from('phone_verification')
          .select()
          .eq('phone', phoneNumber) // try .ilike if phone format might vary
          .eq('otp', inputOtp)
          .gte('expires_at', nowUtc)
          .order('expires_at', ascending: false)
          .limit(1)
          .maybeSingle();

      print("Result: $result");

      if (result != null) {
        return right(true);
      } else {
        return left(Failure("Invalid or expired OTP."));
      }
    } catch (e) {
      return left(Failure("Unexpected error during OTP verification: $e"));
    }
  }






Failure handleError(String context, dynamic e, [StackTrace? stackTrace]) {
  // Print debug info during development
  debugPrint('❌ [$context] Error: $e');
  if (stackTrace != null) {
    debugPrintStack(label: '🔍 StackTrace', stackTrace: stackTrace);
  }

  // Map known error types
  if (e is AuthException) {
    return Failure('Auth error: ${e.message}');
  } else if (e is PostgrestException) {
    return Failure('Database error: ${e.message}');
  } else if (e is StorageException) {
    return Failure('Storage error: ${e.message}');
  } else if (e is SocketException) {
    return Failure('Network error. Please check your internet connection.');
  }

  return Failure('Unexpected error in $context: ${e.toString()}');
}





}
