part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

class MeetingInitial extends MeetingState {}


 // Random Id Generated State
class MeetingGeneratedIdState extends MeetingState {
  final String meetingId;
  MeetingGeneratedIdState(this.meetingId);
}


// meeting Setting Section states
class MeetingCameraToggledState extends MeetingState {}

class MeetingMicrophoneToggledState extends MeetingState {}

class MeetingSpeakerToggledState extends MeetingState {}


// Duration Selected State
class MeetingDurationSelectedState extends MeetingState {}


// Meeting Create States
class MeetingCreateLoadingState extends MeetingState {}

class MeetingCreateSuccessState extends MeetingState {
  final String meetingId;
  MeetingCreateSuccessState(this.meetingId);
}

class MeetingCreateFailedState extends MeetingState {}
