// FILEPATH: /d:/flutter_pro/mtfarm2/mtfarm2/lib/models/recent_activity_model.dart

enum ActivityType { populasi, mortal, potong }

class RecentActivity {
  final int id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;

  RecentActivity({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory RecentActivity.fromMap(Map<String, dynamic> map) {
    return RecentActivity(
      id: map['id'],
      type: ActivityType.values
          .firstWhere((e) => e.toString() == 'ActivityType.${map['type']}'),
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
