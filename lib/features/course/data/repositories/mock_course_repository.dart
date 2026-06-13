import '../../domain/entities/course.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/mock_course_data_source.dart';
import '../mappers/course_mapper.dart';

/// Repository implementation dùng mock data source.
///
/// Class này nằm ở data layer và implement contract của domain.
/// Presentation/use case chỉ cần biết `CourseRepository`, không cần biết
/// dữ liệu đang lấy từ mock list, API hay database.
class MockCourseRepository implements CourseRepository {
  final MockCourseDataSource _dataSource;

  const MockCourseRepository(this._dataSource);

  @override
  Future<List<Course>> getCourses() async {
    final models = await _dataSource.getCourses();
    return models.map((model) => model.toDomain()).toList();
  }

  @override
  Future<Course?> getCourseById(String id) async {
    final model = await _dataSource.getCourseById(id);
    return model?.toDomain();
  }
}
