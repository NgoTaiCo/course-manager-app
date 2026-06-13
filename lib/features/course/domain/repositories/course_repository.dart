import '../entities/course.dart';

/// Giao diện trừu tượng để domain/use case lấy dữ liệu khóa học.
///
/// M2 chỉ tạo interface, chưa tạo implementation.
/// Sang M3, mock repository hoặc data source sẽ implement contract này.
///
/// Lợi ích:
/// - Use case không phụ thuộc static list.
/// - UI/BLoC sau này không cần biết dữ liệu đến từ mock hay API.
/// - Có thể thay implementation mà không đổi domain layer.
abstract class CourseRepository {
  /// Lấy danh sách khóa học ở dạng domain entity.
  Future<List<Course>> getCourses();

  /// Lấy một khóa học theo id.
  ///
  /// Trả về `null` khi không tìm thấy thay vì throw trực tiếp từ domain contract.
  Future<Course?> getCourseById(String id);
}
