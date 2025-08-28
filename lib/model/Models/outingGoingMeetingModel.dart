class Outinggoingmeetingmodel {

  final String id;
  final String hostId;
  final String meetingName;
  final String startTime;
  final String hostName;
  final String hostImage;

  Outinggoingmeetingmodel({
    required this.id,
    required this.hostId,
    required this.meetingName,
    required this.startTime,
    required this.hostName,
    required this.hostImage,
  });

  factory Outinggoingmeetingmodel.fromJson(Map<String, dynamic> json) {
    return Outinggoingmeetingmodel(
      id: json['id'],
      hostId: json['host_id'],
      meetingName: json['meeting_name'],
      startTime: json['start_time'],
      hostName: json['host_name'],
      hostImage: json['host_image'],
    );
  }
}