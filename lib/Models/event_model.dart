
class Event {
  final int id;
  final String mainImage;
  final String photo1;
  final String photo2;
  final String name;
  final String description;
  final DateTime eventRegisterStartDate;
  final DateTime eventRegisterEndDate;
  final DateTime eventStartDate;
  final DateTime eventEndDate;
  final String eventStartTime;
  final int totalParticipant;
  final int departmentId;
  final int categoryId;
  final int organizerId;
  final int venueId;

  Event({
    required this.id,
    required this.mainImage,
    required this.photo1,
    required this.photo2,
    required this.name,
    required this.description,
    required this.eventRegisterStartDate,
    required this.eventRegisterEndDate,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventStartTime,
    required this.totalParticipant,
    required this.departmentId,
    required this.categoryId,
    required this.organizerId,
    required this.venueId,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      mainImage: json['main_image'],
      photo1: json['photo_1'],
      photo2: json['photo_2'],
      name: json['name'],
      description: json['description'],
      eventRegisterStartDate: DateTime.parse(json['event_register_start_date']),
      eventRegisterEndDate: DateTime.parse(json['event_register_end_date']),
      eventStartDate: DateTime.parse(json['event_start_date']),
      eventEndDate: DateTime.parse(json['event_end_date']),
      eventStartTime: json['event_start_time'],
      totalParticipant: json['total_participant'],
      departmentId: json['department_id'],
      categoryId: json['category_id'],
      organizerId: json['organizer_id'],
      venueId: json['venue_id'],
    );
  }

  Object? toJson() {
    return null;
  }
}
