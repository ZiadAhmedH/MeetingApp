import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());
  static MeetingCubit get(context) => BlocProvider.of(context);


  final navigatorKey = GlobalKey<NavigatorState>();

  String meetingId = '';


  bool isCameraOn = true;
  bool isMicrophoneOn = true;
  bool isSpeakerOn = true;

  int selectedDuration = 60;
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

  void selectDuration(int index) {
    selectedDuration = index;
    emit(MeetingDurationSelectedState());
  }



 Future<void> createMeeting({
  required String meetingId,
  required int durationMin,
  required bool cameraOn,
  required bool micOn,
}) async {
  emit(MeetingCreateLoadingState());

  try {
    await Supabase.instance.client
        .from('meetings')
        .insert({
          'id': meetingId,
          'host_id': Supabase.instance.client.auth.currentUser!.id,
          'title': 'Call $meetingId',
          'description': '',
          'created_at': DateTime.now().toIso8601String(),
           'ended_at': DateTime.now().toIso8601String(), // <-- required

        });

    emit(MeetingCreateSuccessState(meetingId));
    print('Meeting created successfully: $meetingId');

  } catch (e)  {
    print('Error creating meeting: $e');
    emit(MeetingCreateFailedState(errorMessage: e.toString()));
  }
}

 Future<void> updateMeetingDuration(String meetingId, int durationMin) async {
    try {
      await Supabase.instance.client
          .from('meetings')
          .update({'ended_at': durationMin})
          .eq('id', meetingId);
      print('Meeting duration updated: $durationMin minutes');
    } catch (e) {
      print('Failed to update meeting duration: $e');
    }
  }


Future<void> logJoinEvent({ required String meetingId}) async {
  try {
    final user = Supabase.instance.client.auth.currentUser!;
    await Supabase.instance.client.from('participants').insert({
      'meeting_id': meetingId,
      'participant_id': user.id,
      'joined_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    print('Error logging join evenddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddt: $e');
  }
}






   void generateRandomId() {
    final random = Random();
    meetingId =  '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}'
        '${random.nextInt(10)}';

    emit(MeetingGeneratedIdState(meetingId));
  }

}





  






 








