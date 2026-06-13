/// Model dữ liệu cho enrollment ở data layer.
///
/// M5 dùng model này để fake enrollment flow giống dữ liệu ngoài hệ thống,
/// sau đó mapper mới chuyển sang domain `Enrollment`.
class EnrollmentModel {
  final String id;
  final String courseId;
  final String userId;
  final String enrolledAt;
  final String status;
  final String? completedAt;

  const EnrollmentModel({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.enrolledAt,
    required this.status,
    required this.completedAt,
  });

  factory EnrollmentModel.fromJson(Map<String, Object?> json) {
    return EnrollmentModel(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      enrolledAt: json['enrolledAt'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      completedAt: json['completedAt'] as String?,
    );
  }
}
