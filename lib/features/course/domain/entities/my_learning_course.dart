import 'course.dart';
import 'user_progress.dart';

/// Thực thể ghép cho màn hình "Khóa học của tôi".
///
/// Domain vẫn giữ `Course` và `UserProgress` tách riêng, nhưng màn hình học tập
/// thường cần cả hai để hiển thị card, progress bar và hành động học tiếp.
class MyLearningCourse {
  final Course course;
  final UserProgress progress;

  const MyLearningCourse({
    required this.course,
    required this.progress,
  });

  /// Id bài học tiếp theo để mock update progress.
  ///
  /// M6 chưa tạo danh sách lesson thật cho từng khóa, nên tạm dùng quy ước
  /// `courseId_lesson_index` để demo progress thay đổi được.
  String? get nextLessonId {
    if (progress.isCompleted) return null;
    final nextOrder = progress.completedLessonCount + 1;
    return '${course.id}_lesson_$nextOrder';
  }
}
