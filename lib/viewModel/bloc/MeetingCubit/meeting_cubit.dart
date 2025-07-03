import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/meetingModel.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/SharedPrefrences.dart';

part 'meeting_state.dart';

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());
  static MeetingCubit get(context) => BlocProvider.of(context);


  final navigatorKey = GlobalKey<NavigatorState>();

  String meetingId = '';


  // meeting Setting Section
  bool isCameraOn = true;
  bool isMicrophoneOn = true;
  bool isSpeakerOn = true;

  //List<String> durationList = ['15 min', '30 min', '45 min', '60 min'];
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



  Future<void> onMeetingEnded({
    required String meetingId,
    required int durationMin,
    required bool cameraOn,
    required bool micOn,
  }) async {
    // Emits loading state
    emit(MeetingCreateLoadingState());
    try {
      // Save to Supabase
      final res = await Supabase.instance.client
        .from('meetings')
        .insert({
          'id': meetingId,
          'host_id': Supabase.instance.client.auth.currentUser!.id,
          'title': 'Call $meetingId',
          'description': '',
          'scheduled_at': new DateTime.now().toIso8601String(),
        });
      if (res.error != null) throw res.error!;
      emit(MeetingCreateSuccessState(meetingId));
        
        print('Meeting created successfully: $meetingId');

    } catch (e) {
      print('Error creating meeting: $e');
      emit(MeetingCreateFailedState(
        errorMessage: e.toString()
      ));
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





  






 








