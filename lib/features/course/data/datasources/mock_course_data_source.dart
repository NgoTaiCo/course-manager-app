import '../../course_data.dart';
import '../models/course_model.dart';

/// Data source mock cho feature course.
///
/// Đây là nơi giả lập nguồn dữ liệu bên ngoài domain:
/// - delay để UI/BLoC sau này test loading state;
/// - fake error để test failure state;
/// - dữ liệu trả về là `CourseModel`, không phải domain entity.
class MockCourseDataSource {
  final Duration delay;
  final bool shouldFail;

  const MockCourseDataSource({
    this.delay = const Duration(milliseconds: 700),
    this.shouldFail = false,
  });

  /// Lấy toàn bộ khóa học từ mock list.
  ///
  /// Nếu [shouldFail] là true, method sẽ throw để giả lập lỗi data source.
  Future<List<CourseModel>> getCourses() async {
    await Future<void>.delayed(delay);

    if (shouldFail) {
      throw const MockCourseDataSourceException(
        'Không thể tải danh sách khóa học từ mock data source.',
      );
    }

    return mockCourseJsonList.map(CourseModel.fromJson).toList();
  }

  /// Lấy một khóa học theo id từ mock list.
  Future<CourseModel?> getCourseById(String id) async {
    await Future<void>.delayed(delay);

    if (shouldFail) {
      throw const MockCourseDataSourceException(
        'Không thể tải chi tiết khóa học từ mock data source.',
      );
    }

    final courses = mockCourseJsonList.map(CourseModel.fromJson);

    for (final course in courses) {
      if (course.id == id) return course;
    }

    return null;
  }
}

/// Exception riêng của mock data source.
///
/// M3 chưa tạo Failure/Result đầy đủ; phần chuẩn hóa lỗi sẽ làm rõ hơn
/// ở các milestone sau.
class MockCourseDataSourceException implements Exception {
  final String message;

  const MockCourseDataSourceException(this.message);

  @override
  String toString() => message;
}
