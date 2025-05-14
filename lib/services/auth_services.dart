import 'dart:ffi';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meeting_app/config/error/failure.dart';
import 'package:meeting_app/model/Models/UserModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign up method
  Future<Either<Failure, UserModel>> signUp(
    String email,
    String password,
    String name, {
    String? phone,
    String? location,
    String? jobTitle,
    String? profileImage,
  }) async {
    try {
      final res = await _supabase.auth.signUp(email: email, password: password);
      final user = res.user;

      if (user != null) {
        final uid = user.id;

        // Optionally handle profile image upload to Supabase Storage
        String? uploadedImageUrl;
        if (profileImage != null) {
          uploadedImageUrl = await _uploadProfileImage(profileImage);
        }

        final newUser = UserModel(
          userName: name,
          email: email,
          uid: uid,
          phone: phone ?? '',
          location: location ?? '',
          jobTitle: jobTitle ?? '',
          profileImage: uploadedImageUrl,
        );

        final insertRes = await _supabase.from('users').insert({
          'UserName': newUser.userName,
          'Email': newUser.email,
          'uid': newUser.uid,
          'phone': newUser.phone,
          'Location': newUser.location,
          'JobTitle': newUser.jobTitle,
          'profileImage': newUser.profileImage,
        });

        if (insertRes.error != null) {
          return left(Failure('Error inserting user data: ${insertRes.error!.message}'));
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

  // Sign in method
  Future<Either<Failure, UserModel>> signIn(String email, String password) async {
    try {
      final res = await _supabase.auth.signInWithPassword(email: email, password: password);
      final user = res.user;

      if (user != null) {
        final data = await _supabase
            .from('users')
            .select()
            .eq('uid', user.id)
            .maybeSingle();

        if (data == null) {
          return left(Failure('User data not found.'));
        }

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

  // Sign out method
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Upload profile image to Supabase Storage (example function)
  Future<String?> _uploadProfileImage(String profileImagePath) async {
    try {
      final file = await _getFileFromPath(profileImagePath); // You need to implement this method
      final fileName = 'profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadRes = await _supabase.storage.from('avatars').upload(fileName, file);

      if (uploadRes != null) {
        return null;
      }

      final fileUrl = await _supabase.storage.from('avatars').getPublicUrl(fileName);
      return fileUrl;
    } catch (e) {
      return null;
    }
  }

  // Helper method to convert a file path to a file
  Future<File> _getFileFromPath(String path) async {
    // Example method to get a file from path, customize based on how you store images
    return File(path);
  }

  // Send OTP to user's phone number
 Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
  try {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
    return right("OTP sent successfully");
  } on AuthException catch (e) {
    return left(Failure("Auth error: ${e.message}"));
  } catch (e) {
    return left(Failure("Unexpected error during OTP sending: $e"));
  }
}


Future<Either<Failure, bool>> verifyOtp({required String phoneNumber,required String otp}) async {
  try {
    final AuthResponse res = await _supabase.auth.verifyOTP(
      phone: phoneNumber,
      token: otp,
      type: OtpType.sms,
    );

   print(res);
    return right(true);
  } on AuthException catch (e) {
    return left(Failure("Auth error: ${e.message}"));
  } catch (e) {
    return left(Failure("Unexpected error during OTP verification: $e"));
  }
}

}
