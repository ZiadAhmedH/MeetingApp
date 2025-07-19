part of 'meeting_cubit.dart';

@immutable
abstract class MeetingState {}

/// === INITIAL STATE ===
class MeetingInitial extends MeetingState {}

/// === RANDOM MEETING ID GENERATED ===
class MeetingGeneratedIdState extends MeetingState {
  final String meetingId;
  MeetingGeneratedIdState(this.meetingId);
}

/// === MEETING TOGGLE STATES ===
class MeetingCameraToggledState extends MeetingState {}

class MeetingMicrophoneToggledState extends MeetingState {}

class MeetingSpeakerToggledState extends MeetingState {}

/// === DURATION SELECTION ===
class MeetingDurationSelectedState extends MeetingState {}

/// === MEETING CREATION ===
class MeetingCreateLoadingState extends MeetingState {}

class MeetingCreateSuccessState extends MeetingState {
  final String meetingId;
  MeetingCreateSuccessState(this.meetingId);
}

class MeetingCreateFailedState extends MeetingState {
  final String? errorMessage;
  MeetingCreateFailedState({this.errorMessage});
}

/// === MEETING SAVE RESULT ===
class MeetingSavedSuccess extends MeetingState {}

class MeetingSavedError extends MeetingState {}

/// === MEETING HISTORY ===
class MeetingHistoryLoadingState extends MeetingState {}

class MeetingHistoryLoadedState extends MeetingState {
  final List<Meetinghistorymodel> meetings;
  MeetingHistoryLoadedState({required this.meetings});
}

class MeetingHistoryErrorState extends MeetingState {
  final String errorMessage;
  MeetingHistoryErrorState({required this.errorMessage});
}

/// === OUTGOING MEETINGS ===
class OutgoingMeetingLoadingState extends MeetingState {}

class OutgoingMeetingLoadedState extends MeetingState {
  final List<Map<String, dynamic>> meetings;
  OutgoingMeetingLoadedState(this.meetings);
}

class OutgoingMeetingErrorState extends MeetingState {
  final String error;
  OutgoingMeetingErrorState(this.error);
}
