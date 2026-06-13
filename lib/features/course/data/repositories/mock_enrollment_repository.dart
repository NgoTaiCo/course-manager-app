import '../../domain/entities/enrollment.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/mock_enrollment_data_source.dart';
import '../mappers/enrollment_mapper.dart';

/// Repository implementation cho enrollment flow dùng mock data source.
class MockEnrollmentRepository implements EnrollmentRepository {
  final MockEnrollmentDataSource _dataSource;

  const MockEnrollmentRepository(this._dataSource);

  @override
  Future<Enrollment> enrollCourse({
    required String courseId,
    required String userId,
  }) async {
    final model = await _dataSource.enrollCourse(
      courseId: courseId,
      userId: userId,
    );
    return model.toDomain();
  }
}
