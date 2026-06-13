import '../entities/enrollment.dart';
import '../repositories/enrollment_repository.dart';

/// Ca sử dụng đăng ký học một khóa học.
///
/// Use case này là nơi CourseDetailBloc gọi khi người dùng bấm enroll.
/// Rule phức tạp hơn như kiểm tra đã enroll hay chưa có thể thêm ở đây sau.
class EnrollCourse {
  final EnrollmentRepository _repository;

  const EnrollCourse(this._repository);

  Future<Enrollment> call({
    required String courseId,
    required String userId,
  }) {
    return _repository.enrollCourse(
      courseId: courseId,
      userId: userId,
    );
  }
}
