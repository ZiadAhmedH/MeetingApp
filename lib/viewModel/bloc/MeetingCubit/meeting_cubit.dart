import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_app/model/Models/meetingModel.dart';
import 'package:meeting_app/utils/CollectionConst.dart';
import 'package:meeting_app/viewModel/data/SharedKeys.dart';
import 'package:meeting_app/viewModel/data/SharedPrefrences.dart';
import 'package:meta/meta.dart';

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





  Future<void> createMeeting() async {
    emit(MeetingCreateLoadingState());
    MeetingModel(createdAt: DateTime.timestamp(), duration: , isCameraOn: isCameraOn, isMicrophoneOn: isMicrophoneOn, isSpeakerOn: isSpeakerOn, meetingId: meetingId);
    await FirebaseFirestore.instance.collection(Collections.users).doc(LocalData.getData(key: SharedKey.uid)).collection(Collections.meetings).add({
      'meetingId': meetingId,
      'isCameraOn': isCameraOn,
      'isMicrophoneOn': isMicrophoneOn,
      'isSpeakerOn': isSpeakerOn,
      'duration': "$selectedDuration min",
      'createdAt': Timestamp.now(),
    }).then((value) {
      emit(MeetingCreateSuccessState(meetingId));
    }).catchError((error) {
      emit(MeetingCreateFailedState());
    });

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
