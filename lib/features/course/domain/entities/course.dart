/// Trạng thái nghiệp vụ của một khóa học.
///
/// M2 chuyển từ String sang enum để tránh typo như `publised`.
/// Đây vẫn là domain concept, không phải label hiển thị trên UI.
enum CourseStatus {
  published,
  draft,
  archived,
}

/// Mức độ khó của khóa học.
///
/// UI có thể hiển thị thành "Cơ bản", "Trung cấp", "Nâng cao",
/// nhưng domain chỉ giữ ý nghĩa nghiệp vụ ổn định.
enum CourseLevel {
  beginner,
  intermediate,
  advanced,
}

/// Thực thể domain đại diện cho một khóa học.
///
/// Điểm quan trọng của M2:
/// - Không import Flutter.
/// - Không có `fromJson` / `toJson`.
/// - Không biết dữ liệu đến từ mock, API hay database.
/// - Chỉ giữ dữ liệu và rule nghiệp vụ đơn giản của khóa học.
///
/// Vấn đề còn để dành cho các milestone sau:
/// - Mapper từ DTO/model sang entity chưa có.
/// - Repository implementation chưa có.
/// - UI vẫn đang dùng entity trực tiếp.
class Course {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String categoryName;
  final CourseStatus status;
  final CourseLevel level;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final int enrollmentCount;
  final int durationMinutes;
  final int lessonCount;
  final List<String> tags;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.categoryName,
    required this.status,
    required this.level,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.enrollmentCount,
    required this.durationMinutes,
    required this.lessonCount,
    required this.tags,
  });

  bool get isPublished => status == CourseStatus.published;

  bool get isDraft => status == CourseStatus.draft;

  bool get isArchived => status == CourseStatus.archived;

  /// Business rule: chỉ khóa đã publish mới cho phép đăng ký.
  ///
  /// UI có thể dùng getter này thay vì tự so sánh trạng thái.
  bool get canEnroll => isPublished;

  /// Business rule: chỉ xem là giảm giá khi giá gốc lớn hơn giá hiện tại.
  bool get hasDiscount => originalPrice > price && originalPrice > 0;

  /// Format tạm để UI hiện thời còn dùng được.
  ///
  /// Về lâu dài có thể cân nhắc đưa formatting thuần hiển thị ra presentation.
  String get durationFormatted {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  /// Tính phần trăm giảm giá từ dữ liệu domain hiện có.
  double get discountPercent {
    if (!hasDiscount) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }
}
