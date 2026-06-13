/// Model dữ liệu của khóa học ở data layer.
///
/// M3 cố ý tách `CourseModel` khỏi domain `Course` để học viên thấy:
/// - Data layer có thể dùng String giống API/JSON.
/// - Domain layer dùng enum và rule nghiệp vụ ổn định hơn.
/// - Mapper chịu trách nhiệm chuyển đổi giữa hai thế giới.
///
/// M4 bổ sung `fromJson` để học viên thấy parse JSON nằm ở data layer,
/// không nằm trong domain entity.
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructorName;
  final String categoryName;
  final String status;
  final String level;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final int enrollmentCount;
  final int durationMinutes;
  final int lessonCount;
  final List<String> tags;

  const CourseModel({
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

  /// Parse dữ liệu thô kiểu JSON/map sang data model.
  ///
  /// Trong app thật, object này có thể đến từ API response hoặc local JSON.
  /// Ở repo học tập này, dữ liệu được đặt trong `course_data.dart`.
  factory CourseModel.fromJson(Map<String, Object?> json) {
    return CourseModel(
      id: _readString(json, 'id'),
      title: _readString(json, 'title'),
      description: _readString(json, 'description'),
      instructorName: _readString(json, 'instructorName'),
      categoryName: _readString(json, 'categoryName'),
      status: _readString(json, 'status'),
      level: _readString(json, 'level'),
      price: _readDouble(json, 'price'),
      originalPrice: _readDouble(json, 'originalPrice'),
      rating: _readDouble(json, 'rating'),
      reviewCount: _readInt(json, 'reviewCount'),
      enrollmentCount: _readInt(json, 'enrollmentCount'),
      durationMinutes: _readInt(json, 'durationMinutes'),
      lessonCount: _readInt(json, 'lessonCount'),
      tags: _readStringList(json, 'tags'),
    );
  }

  static String _readString(Map<String, Object?> json, String key) {
    return json[key] as String? ?? '';
  }

  static double _readDouble(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0;
  }

  static int _readInt(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  static List<String> _readStringList(Map<String, Object?> json, String key) {
    final value = json[key];
    if (value is List) {
      return value.whereType<String>().toList();
    }
    return const [];
  }
}
