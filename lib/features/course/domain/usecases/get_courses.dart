import '../entities/course.dart';
import '../repositories/course_repository.dart';

/// Ca sử dụng đầu tiên của feature course.
///
/// Mục tiêu của M2 là để BLoC/UI sau này gọi vào ca sử dụng thay vì gọi thẳng
/// static list hoặc data source. Hiện tại use case chỉ delegate sang
/// repository contract; các rule phức tạp hơn sẽ thêm khi bài học cần.
class GetCourses {
  final CourseRepository _repository;

  const GetCourses(this._repository);

  /// Cho phép gọi ca sử dụng như một function: `getCourses()`.
  Future<List<Course>> call() {
    return _repository.getCourses();
  }
}
