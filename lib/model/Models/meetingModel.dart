
import 'package:intl/intl.dart';

class MeetingModel {
  DateTime createdAt;
  String duration;
  bool isCameraOn;
  bool isMicrophoneOn;
  bool isSpeakerOn;
  String meetingId;

  MeetingModel({
    required this.createdAt,
    required this.duration,
    required this.isCameraOn,
    required this.isMicrophoneOn,
    required this.isSpeakerOn,
    required this.meetingId,
  });

  factory MeetingModel.fromMap(Map<String, dynamic> map) {
    return MeetingModel(
      createdAt: DateTime.parse(map['createdAt']),
      duration: map['duration'],
      isCameraOn: map['isCameraOn'],
      isMicrophoneOn: map['isMicrophoneOn'],
      isSpeakerOn: map['isSpeakerOn'],
      meetingId: map['meetingId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(createdAt),
      'duration': duration,
      'isCameraOn': isCameraOn,
      'isMicrophoneOn': isMicrophoneOn,
      'isSpeakerOn': isSpeakerOn,
      'meetingId': meetingId,
    };
  }
}
