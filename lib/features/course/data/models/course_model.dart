/// Model dữ liệu của khóa học ở data layer.
///
/// M3 cố ý tách `CourseModel` khỏi domain `Course` để học viên thấy:
/// - Data layer có thể dùng String giống API/JSON.
/// - Domain layer dùng enum và rule nghiệp vụ ổn định hơn.
/// - Mapper chịu trách nhiệm chuyển đổi giữa hai thế giới.
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
}
