import '../entities/user_progress.dart';
import '../repositories/learning_repository.dart';

/// Ca sử dụng cập nhật tiến độ khi hoàn thành một bài học.
class UpdateLessonProgress {
  final LearningRepository _repository;

  const UpdateLessonProgress(this._repository);

  Future<UserProgress> call({
    required String userId,
    required String courseId,
    required String lessonId,
  }) {
    return _repository.updateLessonProgress(
      userId: userId,
      courseId: courseId,
      lessonId: lessonId,
    );
  }
}
