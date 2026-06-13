import '../../domain/entities/course.dart';
import '../models/course_model.dart';

/// Mapper chuyển `CourseModel` ở data layer sang `Course` ở domain layer.
///
/// Đây là boundary quan trọng của M3:
/// - Data layer có thể dùng String/raw field.
/// - Domain layer không cần biết raw data được biểu diễn thế nào.
/// - Nếu API đổi field hoặc enum value, ta sửa mapper/data layer trước.
extension CourseModelMapper on CourseModel {
  Course toDomain() {
    return Course(
      id: id,
      title: title,
      description: description,
      instructorName: instructorName,
      categoryName: categoryName,
      status: _mapStatus(status),
      level: _mapLevel(level),
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      reviewCount: reviewCount,
      enrollmentCount: enrollmentCount,
      durationMinutes: durationMinutes,
      lessonCount: lessonCount,
      tags: tags,
    );
  }

  CourseStatus _mapStatus(String value) {
    return switch (value) {
      'published' => CourseStatus.published,
      'draft' => CourseStatus.draft,
      'archived' => CourseStatus.archived,
      _ => CourseStatus.draft,
    };
  }

  CourseLevel _mapLevel(String value) {
    return switch (value) {
      'beginner' => CourseLevel.beginner,
      'intermediate' => CourseLevel.intermediate,
      'advanced' => CourseLevel.advanced,
      _ => CourseLevel.beginner,
    };
  }
}
