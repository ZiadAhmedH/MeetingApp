import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> generateToken({required String roomId, required String userId}) async {
  final supabase = Supabase.instance.client;

  // Step 1: Get the current access token from Supabase
  final accessToken = supabase.auth.currentSession?.accessToken;

  if (accessToken == null) {
    throw Exception('User is not authenticated. Please log in.');
  }

  final dio = Dio();

  try {
    final response = await dio.post(
      'https://savwcqlrhixilqbryyff.supabase.co/functions/v1/generate-zego-token',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "roomId": roomId,
        "userId": userId,
      },
    );

    // Step 3: Return the token
    final token = response.data['token'];
    if (token == null) {
      throw Exception('Token not found in the response.');
    }

    return token;
  } on DioException catch (e) {
    if (e.response != null) {
      print('[Dio Error] Status: ${e.response?.statusCode}, Body: ${e.response?.data}');
    } else {
      print('[Dio Error] Message: ${e.message}');
    }
    rethrow;
  }
}
