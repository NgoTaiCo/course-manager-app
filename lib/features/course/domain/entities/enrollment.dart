/// Trạng thái học viên trong một khóa học.
///
/// Dùng enum để các use case sau không phải truyền String rời rạc.
enum EnrollmentStatus {
  active,
  completed,
  cancelled,
}

/// Thực thể domain đại diện cho việc một học viên đăng ký một khóa học.
///
/// Entity này chưa xử lý thanh toán, certificate hay refund.
/// Trong A01, enrollment chỉ dùng để minh họa business action:
/// học viên bắt đầu học, tiếp tục học, hoàn thành hoặc hủy đăng ký.
class Enrollment {
  final String id;
  final String courseId;
  final String userId;
  final DateTime enrolledAt;
  final EnrollmentStatus status;
  final DateTime? completedAt;

  const Enrollment({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.enrolledAt,
    required this.status,
    this.completedAt,
  });

  /// Học viên chỉ tiếp tục học khi enrollment còn active.
  bool get canContinueLearning => status == EnrollmentStatus.active;

  bool get isCompleted => status == EnrollmentStatus.completed;

  bool get isCancelled => status == EnrollmentStatus.cancelled;
}
