import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Ca sử dụng lấy chi tiết một khóa học theo id.
///
/// M5 dùng use case này để CourseDetailBloc không nhận trực tiếp object
/// `Course` từ màn hình list nữa.
class GetCourseDetail {
  final CourseRepository _repository;

  const GetCourseDetail(this._repository);

  Future<Course?> call(String courseId) {
    return _repository.getCourseById(courseId);
  }
}
