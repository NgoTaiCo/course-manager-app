import '../models/enrollment_model.dart';

/// Data source mock cho enrollment.
///
/// Có fake delay và fake failure để CourseDetailBloc demo được trạng thái
/// submitting/success/failure khi bấm đăng ký.
class MockEnrollmentDataSource {
  final Duration delay;
  final bool shouldFail;

  const MockEnrollmentDataSource({
    this.delay = const Duration(milliseconds: 600),
    this.shouldFail = false,
  });

  Future<EnrollmentModel> enrollCourse({
    required String courseId,
    required String userId,
  }) async {
    await Future<void>.delayed(delay);

    if (shouldFail) {
      throw const MockEnrollmentDataSourceException(
        'Không thể đăng ký khóa học ở mock enrollment data source.',
      );
    }

    final now = DateTime.now();

    return EnrollmentModel.fromJson({
      'id': 'enr_${courseId}_$userId',
      'courseId': courseId,
      'userId': userId,
      'enrolledAt': now.toIso8601String(),
      'status': 'active',
      'completedAt': null,
    });
  }
}

/// Exception riêng cho enrollment mock.
class MockEnrollmentDataSourceException implements Exception {
  final String message;

  const MockEnrollmentDataSourceException(this.message);

  @override
  String toString() => message;
}
