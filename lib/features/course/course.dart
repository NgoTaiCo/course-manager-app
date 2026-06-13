/// Đây là một plain Dart class, không có repository, không có use case,
/// không có mapper. Dữ liệu được hardcode trực tiếp trong static list
/// và Widget tự truy cập không qua bất kỳ abstraction nào.
///
/// Điểm sẽ gây vấn đề khi app lớn lên:
/// - `status` và `level` là String — dễ typo, không type-safe.
/// - Không có boundary giữa data và UI.
/// - Thêm filter/search sẽ viết thẳng trong Widget.
class Course {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String categoryName;

  /// 'published' | 'draft' | 'archived'
  final String status;

  /// 'beginner' | 'intermediate' | 'advanced'
  final String level;

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

  String get durationFormatted {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  double get discountPercent {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }
}
