import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/meetingHistoryModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());

  static MeetingCubit get(context) => BlocProvider.of(context);
  final SupabaseClient _client = Supabase.instance.client;

  final navigatorKey = GlobalKey<NavigatorState>();

  String meetingId = '';
  bool isCameraOn = true;
  bool isMicrophoneOn = true;
  bool isSpeakerOn = true;
  int selectedDuration = 60;

  // ==================== UI Toggles ====================
  void toggleCamera() {
    isCameraOn = !isCameraOn;
    emit(MeetingCameraToggledState());
  }

  void toggleMicrophone() {
    isMicrophoneOn = !isMicrophoneOn;
    emit(MeetingMicrophoneToggledState());
  }

  void toggleSpeaker() {
    isSpeakerOn = !isSpeakerOn;
    emit(MeetingSpeakerToggledState());
  }

  void selectDuration(int minutes) {
    selectedDuration = minutes;
    emit(MeetingDurationSelectedState());
  }

  void generateRandomId() {
    final random = Random();
    meetingId = List.generate(6, (_) => random.nextInt(10)).join();
    emit(MeetingGeneratedIdState(meetingId));
  }

  // ==================== CREATE MEETING ====================
  Future<void> createMeeting({
    required String meetingId,
    required int durationMin,
    required bool cameraOn,
    required bool micOn,
  }) async {
    emit(MeetingCreateLoadingState());

    try {
      await _client.from('meetings').insert({
        'id': meetingId,
        'host_id': _client.auth.currentUser!.id,
        'title': 'Meeting $meetingId',
        'description': '',
        'created_at': DateTime.now().toIso8601String(),
        'ended_at': DateTime.now().toIso8601String(), // You can later update this
      });

      emit(MeetingCreateSuccessState(meetingId));
      print('✅ Meeting created successfully: $meetingId');
    } catch (e) {
      print('❌ Error creating meeting: $e');
      emit(MeetingCreateFailedState(errorMessage: e.toString()));
    }
  }

  // ==================== OUTGOING MEETING ====================
  Future<void> putItForOutgoingMeeting(String meetingId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _client.from('outgoing_meetings').insert({
        'id': meetingId,
        'host_id': userId,
        'meeting_name': 'Meeting $meetingId',
        'start_time': DateTime.now().toIso8601String(),
      });
      print("✅ Meeting added to outgoing list");
    } catch (e) {
      print("❌ Error inserting outgoing meeting: $e");
    }
  }

  Future<void> deleteOutgoingMeeting(String meetingId) async {
    try {
      await _client
          .from('outgoing_meetings')
          .delete()
          .eq('id', meetingId);
      print("🗑️ Meeting deleted from outgoing list");
    } catch (e) {
      print("❌ Error deleting outgoing meeting: $e");
    }
  }

 Stream<List<Map<String, dynamic>>> getLiveOutgoingMeetings() {
  return _client
      .from('outgoing_meetings')
      .stream(primaryKey: ['id'])
      .order('start_time')
      .map((event) {
        print("📡 Stream emitted ${event.length} meetings");
        return event;
      });
}


  // ==================== MEETING HISTORY ====================
  Future<void> getMeetingHistory({required String userId}) async {
    if (isClosed) return; // ✅ Prevent emitting after close
     emit(MeetingHistoryLoadingState());
    try {
      final response = await _client
          .from('meetings')
          .select()
          .eq('host_id', userId)
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      final meetings = data
          .map((json) => Meetinghistorymodel.fromJson(json))
          .toList();

      emit(MeetingHistoryLoadedState(meetings: meetings));
    } catch (e) {
      print('❌ Error fetching meeting history: $e');
      emit(MeetingHistoryErrorState(errorMessage: e.toString()));
    }
  }

  // ==================== PARTICIPANT JOIN ====================
  Future<void> logJoinEvent({required String meetingId}) async {
    try {
      final user = _client.auth.currentUser!;
      await _client.from('participants').insert({
        'meeting_id': meetingId,
        'participant_id': user.id,
        'joined_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('❌ Error logging join event: $e');
    }
  }

  // ==================== MEETING ENDING ====================
  Future<void> updateMeetingDuration(String meetingId, int durationMin) async {
    try {
      await _client
          .from('meetings')
          .update({'ended_at': durationMin}).eq('id', meetingId);
      print('✅ Meeting duration updated: $durationMin minutes');
    } catch (e) {
      print('❌ Failed to update meeting duration: $e');
    }
  }
}
