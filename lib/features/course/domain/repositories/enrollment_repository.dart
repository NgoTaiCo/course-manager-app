import '../entities/enrollment.dart';

/// Giao diện trừu tượng cho nghiệp vụ đăng ký khóa học.
///
/// Domain/use case chỉ biết contract này, không biết enrollment đang được
/// lưu ở memory, local database hay API.
abstract class EnrollmentRepository {
  /// Đăng ký một học viên vào một khóa học.
  Future<Enrollment> enrollCourse({
    required String courseId,
    required String userId,
  });
}
