class QuarantineEvent {
  const QuarantineEvent({
    required this.eventId,
    required this.reason,
    required this.createdAt,
    required this.payload,
  });

  final String eventId;
  final String reason;
  final DateTime createdAt;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'event_id': eventId,
      'reason': reason,
      'created_at': createdAt.toIso8601String(),
      'payload': payload,
    };
  }

  factory QuarantineEvent.fromJson(Map<String, dynamic> json) {
    return QuarantineEvent(
      eventId: json['event_id'] as String,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      payload: Map<String, dynamic>.from(json['payload'] as Map),
    );
  }
}
