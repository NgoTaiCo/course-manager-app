import '../../domain/entities/my_learning_course.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/course_repository.dart';
import '../../domain/repositories/learning_repository.dart';
import '../datasources/mock_learning_data_source.dart';
import '../mappers/user_progress_mapper.dart';

/// Repository implementation cho My Learning dùng mock data source.
class MockLearningRepository implements LearningRepository {
  final MockLearningDataSource _learningDataSource;
  final CourseRepository _courseRepository;

  const MockLearningRepository({
    required MockLearningDataSource learningDataSource,
    required CourseRepository courseRepository,
  })  : _learningDataSource = learningDataSource,
        _courseRepository = courseRepository;

  @override
  Future<List<MyLearningCourse>> getMyCourses(String userId) async {
    final progressModels = await _learningDataSource.getMyProgress(userId);
    final items = <MyLearningCourse>[];

    for (final progressModel in progressModels) {
      final progress = progressModel.toDomain();
      final course = await _courseRepository.getCourseById(progress.courseId);

      if (course != null) {
        items.add(
          MyLearningCourse(
            course: course,
            progress: progress,
          ),
        );
      }
    }

    return items;
  }

  @override
  Future<UserProgress> updateLessonProgress({
    required String userId,
    required String courseId,
    required String lessonId,
  }) async {
    final model = await _learningDataSource.updateLessonProgress(
      userId: userId,
      courseId: courseId,
      lessonId: lessonId,
    );
    return model.toDomain();
  }
}
