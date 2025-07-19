import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/core/services/meeting_services.dart';
import 'package:meeting_app/model/Models/meetingHistoryModel.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  final MeetingService service;

  MeetingCubit(this.service) : super(MeetingInitial()) {
    selfId = LocalData.getData(key: SharedKey.uid) ?? 'anonymous';
  }

  static MeetingCubit get(context) => BlocProvider.of(context);

  final navigatorKey = GlobalKey<NavigatorState>();

  late final String selfId;
  String meetingId = '';
  bool isCameraOn = true;
  bool isMicrophoneOn = true;
  bool isSpeakerOn = true;
  int selectedDuration = 60;


  // ========== UI Toggles ==========
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

  // ========== CREATE MEETING ==========
  Future<void> createMeeting({
    required String meetingId,
    required int durationMin,
    required bool cameraOn,
    required bool micOn,
  }) async {
    emit(MeetingCreateLoadingState());
    try {
      await service.createMeeting( meetingId: meetingId, ); // add meeting details in supabase backend
      await service.putItForOutgoingMeeting(meetingId); // add meeting to outgoing meetings
      emit(MeetingCreateSuccessState(meetingId));
    } catch (e) {
      emit(MeetingCreateFailedState(errorMessage: e.toString()));
    }
  }

  // ========== OUTGOING MEETING ==========
  Future<void> putItForOutgoingMeeting(String meetingId) async {
    try {
      await service.putItForOutgoingMeeting(meetingId);
    } catch (e) {
      print("❌ Error inserting outgoing meeting: $e");
    }
  }

  Future<void> deleteOutgoingMeeting(String meetingId) async {
    try {
      await service.deleteOutgoingMeeting(meetingId);
    } catch (e) {
      print("❌ Error deleting outgoing meeting: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getLiveOutgoingMeetings() {
    return service.getLiveOutgoingMeetings();
  }

  // ========== MEETING HISTORY ==========
  Future<void> getMeetingHistory({required String userId}) async {
    if (isClosed) return;
    emit(MeetingHistoryLoadingState());
    try {
      final meetings = await service.getMeetingHistory(userId);
      emit(MeetingHistoryLoadedState(meetings: meetings));
    } catch (e) {
      emit(MeetingHistoryErrorState(errorMessage: e.toString()));
    }
  }

  // ========== PARTICIPANT JOIN ==========
  Future<void> logJoinEvent({required String meetingId}) async {
    try {
      await service.logJoinEvent(meetingId);
    } catch (e) {
      print('❌ Error logging join event: $e');
    }
  }

  // ========== MEETING ENDING ==========
  Future<void> updateMeetingDuration(String meetingId, int durationMin) async {
    try {
      await service.updateMeetingDuration(meetingId, durationMin);
    } catch (e) {
      print('❌ Failed to update meeting duration: $e');
    }
  }
}
