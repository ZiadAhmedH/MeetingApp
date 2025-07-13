class Meetinghistorymodel {
   
  final String meetingId;
  final String hostId;
  final String meetingName;
  final String meetingDescription;
  final DateTime createdAt;
  final DateTime endedAt;
  Meetinghistorymodel({
    required this.meetingId,
    required this.hostId,
    required this.meetingName,
    required this.meetingDescription,
    required this.createdAt,
    required this.endedAt,
 });

  factory Meetinghistorymodel.fromJson(Map<String, dynamic> json) {
    return Meetinghistorymodel(
      meetingId: json['id'],
      hostId: json['host_id'],
      meetingName: json['title'],
      meetingDescription: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      endedAt: DateTime.parse(json['ended_at']),
    );
  }


}