import '../entities/my_learning_course.dart';
import '../repositories/learning_repository.dart';

/// Ca sử dụng lấy danh sách khóa học của tôi.
class GetMyCourses {
  final LearningRepository _repository;

  const GetMyCourses(this._repository);

  Future<List<MyLearningCourse>> call(String userId) {
    return _repository.getMyCourses(userId);
  }
}
