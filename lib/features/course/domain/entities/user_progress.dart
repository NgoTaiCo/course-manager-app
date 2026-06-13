/// Thực thể domain theo dõi tiến độ học của một học viên trong một khóa học.
///
/// Entity này chỉ lưu trạng thái học tập ở mức domain:
/// - học viên nào;
/// - khóa học nào;
/// - bài nào đã hoàn thành;
/// - bài cuối cùng đang học;
/// - thời điểm cập nhật gần nhất.
///
/// Nó không biết dữ liệu được lưu ở memory, local database hay API.
class UserProgress {
  final String userId;
  final String courseId;
  final List<String> completedLessonIds;
  final int totalLessonCount;
  final String? lastLessonId;
  final DateTime updatedAt;

  const UserProgress({
    required this.userId,
    required this.courseId,
    required this.completedLessonIds,
    required this.totalLessonCount,
    required this.lastLessonId,
    required this.updatedAt,
  });

  /// Số bài đã hoàn thành dựa trên danh sách lesson id.
  int get completedLessonCount => completedLessonIds.length;

  /// Học viên được xem là đã bắt đầu nếu có bài hoàn thành
  /// hoặc có bài cuối cùng đang học.
  bool get hasStarted => completedLessonIds.isNotEmpty || lastLessonId != null;

  /// Hoàn thành khi số bài đã học đạt tổng số bài của khóa.
  bool get isCompleted =>
      totalLessonCount > 0 && completedLessonCount >= totalLessonCount;

  /// Tỷ lệ tiến độ từ 0.0 đến 1.0.
  double get progressRatio {
    if (totalLessonCount <= 0) return 0;
    return completedLessonCount / totalLessonCount;
  }

  /// Trả về một object mới sau khi đánh dấu bài học đã hoàn thành.
  ///
  /// Không mutate object hiện tại để state sau này dễ dự đoán hơn khi dùng BLoC.
  UserProgress markLessonCompleted(String lessonId, DateTime completedAt) {
    final nextCompletedLessonIds = completedLessonIds.contains(lessonId)
        ? completedLessonIds
        : [...completedLessonIds, lessonId];

    return UserProgress(
      userId: userId,
      courseId: courseId,
      completedLessonIds: nextCompletedLessonIds,
      totalLessonCount: totalLessonCount,
      lastLessonId: lessonId,
      updatedAt: completedAt,
    );
  }
}
