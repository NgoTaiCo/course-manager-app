import 'course.dart';
import 'data/datasources/mock_enrollment_data_source.dart';
import 'data/datasources/mock_course_data_source.dart';
import 'data/datasources/mock_learning_data_source.dart';
import 'data/repositories/mock_enrollment_repository.dart';
import 'data/repositories/mock_course_repository.dart';
import 'data/repositories/mock_learning_repository.dart';

/// Nơi lắp dependency tạm cho feature course.
///
/// M4 chưa đưa `get_it` vào để tránh làm bài học quá nặng.
/// File này giúp UI không phải import data source/repository trực tiếp.
CourseListBloc createCourseListBloc({
  bool shouldFail = false,
}) {
  final dataSource = MockCourseDataSource(
    // Đổi thành true để demo lỗi loading/failure.
    shouldFail: shouldFail,
  );
  final repository = MockCourseRepository(dataSource);
  final getCourses = GetCourses(repository);

  return CourseListBloc(getCourses: getCourses);
}

/// Tạo CourseDetailBloc với dependency mock.
///
/// [shouldFailEnrollment] có thể đổi thành true để demo trạng thái enroll lỗi.
CourseDetailBloc createCourseDetailBloc({
  bool shouldFailCourseDetail = false,
  bool shouldFailEnrollment = false,
}) {
  final courseDataSource = MockCourseDataSource(
    shouldFail: shouldFailCourseDetail,
  );
  final courseRepository = MockCourseRepository(courseDataSource);
  final getCourseDetail = GetCourseDetail(courseRepository);

  final enrollmentDataSource = MockEnrollmentDataSource(
    shouldFail: shouldFailEnrollment,
  );
  final enrollmentRepository = MockEnrollmentRepository(enrollmentDataSource);
  final enrollCourse = EnrollCourse(enrollmentRepository);

  return CourseDetailBloc(
    getCourseDetail: getCourseDetail,
    enrollCourse: enrollCourse,
    // User giả lập cho A01. Auth thật nằm ngoài phạm vi milestone này.
    currentUserId: 'learner_01',
  );
}

/// Tạo MyLearningCubit với progress local mock.
///
/// M6 dùng Cubit vì flow chỉ có load và update progress, chưa cần event class.
MyLearningCubit createMyLearningCubit({
  bool shouldFail = false,
}) {
  const courseDataSource = MockCourseDataSource();
  const courseRepository = MockCourseRepository(courseDataSource);

  final learningDataSource = MockLearningDataSource(
    shouldFail: shouldFail,
  );
  final learningRepository = MockLearningRepository(
    learningDataSource: learningDataSource,
    courseRepository: courseRepository,
  );

  final getMyCourses = GetMyCourses(learningRepository);
  final updateLessonProgress = UpdateLessonProgress(learningRepository);

  return MyLearningCubit(
    getMyCourses: getMyCourses,
    updateLessonProgress: updateLessonProgress,
    // User giả lập cho A01. Auth thật nằm ngoài scope.
    currentUserId: 'learner_01',
  );
}
