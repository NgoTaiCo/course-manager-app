/// Loại nội dung của bài học.
///
/// M2 chỉ định nghĩa domain concept, chưa gắn với video player,
/// markdown renderer hoặc quiz engine thật.
enum LessonContentType {
  video,
  article,
  quiz,
}

/// Thực thể domain đại diện cho một bài học trong khóa học.
///
/// Entity này không biết UI render bài học như thế nào.
/// Data layer sau này có thể map từ JSON/API/local database sang `Lesson`.
class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final int order;
  final int durationMinutes;
  final LessonContentType contentType;
  final bool isPreview;

  const Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.order,
    required this.durationMinutes,
    required this.contentType,
    required this.isPreview,
  });

  /// Business rule: bài preview có thể xem trước khi đăng ký khóa học.
  bool get canPreviewWithoutEnrollment => isPreview;

  /// Rule đơn giản để demo cách đặt logic nhỏ trong domain entity.
  bool get isLongLesson => durationMinutes >= 30;
}
