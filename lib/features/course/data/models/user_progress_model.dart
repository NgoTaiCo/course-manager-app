/// Model dữ liệu cho tiến độ học ở data layer.
class UserProgressModel {
  final String userId;
  final String courseId;
  final List<String> completedLessonIds;
  final int totalLessonCount;
  final String? lastLessonId;
  final String updatedAt;

  const UserProgressModel({
    required this.userId,
    required this.courseId,
    required this.completedLessonIds,
    required this.totalLessonCount,
    required this.lastLessonId,
    required this.updatedAt,
  });

  factory UserProgressModel.fromJson(Map<String, Object?> json) {
    return UserProgressModel(
      userId: json['userId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      completedLessonIds: _readStringList(json, 'completedLessonIds'),
      totalLessonCount: json['totalLessonCount'] as int? ?? 0,
      lastLessonId: json['lastLessonId'] as String?,
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'completedLessonIds': completedLessonIds,
      'totalLessonCount': totalLessonCount,
      'lastLessonId': lastLessonId,
      'updatedAt': updatedAt,
    };
  }

  static List<String> _readStringList(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [];
  }
}
