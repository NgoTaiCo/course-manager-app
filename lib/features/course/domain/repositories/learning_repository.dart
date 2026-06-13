import '../entities/my_learning_course.dart';
import '../entities/user_progress.dart';

/// Repository contract cho phần "Khóa học của tôi" và tiến độ học.
abstract class LearningRepository {
  /// Lấy danh sách khóa học mà học viên đang học.
  Future<List<MyLearningCourse>> getMyCourses(String userId);

  /// Cập nhật tiến độ khi học viên hoàn thành một bài học.
  Future<UserProgress> updateLessonProgress({
    required String userId,
    required String courseId,
    required String lessonId,
  });
}
