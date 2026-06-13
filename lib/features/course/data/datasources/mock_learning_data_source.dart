import '../models/user_progress_model.dart';

/// Data source mock cho "Khóa học của tôi".
///
/// Progress được lưu trong memory để demo thay đổi local. Khi restart app,
/// dữ liệu sẽ quay về initial state. Đây là chủ ý của M6 để chưa kéo local DB
/// hoặc backend thật vào bài học.
class MockLearningDataSource {
  final Duration delay;
  final bool shouldFail;
  final Map<String, UserProgressModel> _progressByCourseId;

  MockLearningDataSource({
    this.delay = const Duration(milliseconds: 500),
    this.shouldFail = false,
  }) : _progressByCourseId = _initialProgress();

  Future<List<UserProgressModel>> getMyProgress(String userId) async {
    await Future<void>.delayed(delay);
    _throwIfNeeded('Không thể tải tiến độ học từ mock data source.');

    return _progressByCourseId.values
        .where((progress) => progress.userId == userId)
        .toList();
  }

  Future<UserProgressModel> updateLessonProgress({
    required String userId,
    required String courseId,
    required String lessonId,
  }) async {
    await Future<void>.delayed(delay);
    _throwIfNeeded('Không thể cập nhật tiến độ học từ mock data source.');

    final current = _progressByCourseId[courseId];
    if (current == null || current.userId != userId) {
      throw const MockLearningDataSourceException(
        'Không tìm thấy tiến độ học cho khóa học này.',
      );
    }

    final completedLessonIds = current.completedLessonIds.contains(lessonId)
        ? current.completedLessonIds
        : [...current.completedLessonIds, lessonId];

    final next = UserProgressModel(
      userId: current.userId,
      courseId: current.courseId,
      completedLessonIds: completedLessonIds,
      totalLessonCount: current.totalLessonCount,
      lastLessonId: lessonId,
      updatedAt: DateTime.now().toIso8601String(),
    );

    _progressByCourseId[courseId] = next;
    return next;
  }

  void _throwIfNeeded(String message) {
    if (shouldFail) {
      throw MockLearningDataSourceException(message);
    }
  }

  static Map<String, UserProgressModel> _initialProgress() {
    final now = DateTime.now().toIso8601String();

    return {
      'crs_01': UserProgressModel.fromJson({
        'userId': 'learner_01',
        'courseId': 'crs_01',
        'completedLessonIds': ['crs_01_lesson_1', 'crs_01_lesson_2'],
        'totalLessonCount': 8,
        'lastLessonId': 'crs_01_lesson_2',
        'updatedAt': now,
      }),
      'crs_02': UserProgressModel.fromJson({
        'userId': 'learner_01',
        'courseId': 'crs_02',
        'completedLessonIds': ['crs_02_lesson_1'],
        'totalLessonCount': 6,
        'lastLessonId': 'crs_02_lesson_1',
        'updatedAt': now,
      }),
      'crs_04': UserProgressModel.fromJson({
        'userId': 'learner_01',
        'courseId': 'crs_04',
        'completedLessonIds': const [],
        'totalLessonCount': 5,
        'lastLessonId': null,
        'updatedAt': now,
      }),
    };
  }
}

/// Exception riêng cho mock learning data source.
class MockLearningDataSourceException implements Exception {
  final String message;

  const MockLearningDataSourceException(this.message);

  @override
  String toString() => message;
}
