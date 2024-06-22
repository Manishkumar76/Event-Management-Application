
class Participants {
  late int event_id;
late int user_id;

Participants({
  required this.event_id,
  required this.user_id,
});

factory Participants.fromJson(Map<String, dynamic> json) {
  return Participants(
    event_id: json['event_id'],
    user_id: json['user_id'],
  );
}

  Object? toJson() {}
}