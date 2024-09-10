part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

class MeetingInitial extends MeetingState {}


 // Random Id Generated State
class MeetingGeneratedIdState extends MeetingState {}


// meeting Setting Section states
class MeetingCameraToggledState extends MeetingState {}

class MeetingMicrophoneToggledState extends MeetingState {}

class MeetingSpeakerToggledState extends MeetingState {}


// Duration Selected State
class MeetingDurationSelectedState extends MeetingState {}
