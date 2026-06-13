import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/my_learning_course.dart';
import '../../domain/usecases/get_my_courses.dart';
import '../../domain/usecases/update_lesson_progress.dart';
import 'my_learning_state.dart';

/// Cubit quản lý màn hình "Khóa học của tôi".
///
/// M6 chọn Cubit thay vì BLoC vì flow hiện tại chỉ có vài command trực tiếp:
/// load danh sách và cập nhật progress. Chưa có nhiều event phức tạp như
/// Course List hoặc Course Detail.
class MyLearningCubit extends Cubit<MyLearningState> {
  final GetMyCourses _getMyCourses;
  final UpdateLessonProgress _updateLessonProgress;
  final String _currentUserId;

  MyLearningCubit({
    required GetMyCourses getMyCourses,
    required UpdateLessonProgress updateLessonProgress,
    required String currentUserId,
  })  : _getMyCourses = getMyCourses,
        _updateLessonProgress = updateLessonProgress,
        _currentUserId = currentUserId,
        super(const MyLearningState.initial());

  Future<void> loadMyCourses() async {
    emit(
      state.copyWith(
        status: MyLearningStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final courses = await _getMyCourses(_currentUserId);
      _emitCourses(courses);
    } catch (_) {
      emit(
        state.copyWith(
          status: MyLearningStatus.failure,
          errorMessage: 'Không thể tải khóa học của tôi.',
        ),
      );
    }
  }

  Future<void> completeNextLesson(MyLearningCourse item) async {
    final lessonId = item.nextLessonId;
    if (lessonId == null || state.updatingCourseId == item.course.id) {
      return;
    }

    emit(
      state.copyWith(
        updatingCourseId: item.course.id,
        clearErrorMessage: true,
      ),
    );

    try {
      final nextProgress = await _updateLessonProgress(
        userId: _currentUserId,
        courseId: item.course.id,
        lessonId: lessonId,
      );

      final nextCourses = state.courses.map((course) {
        if (course.course.id != item.course.id) return course;
        return MyLearningCourse(
          course: course.course,
          progress: nextProgress,
        );
      }).toList();

      emit(
        state.copyWith(
          courses: nextCourses,
          status: nextCourses.isEmpty
              ? MyLearningStatus.empty
              : MyLearningStatus.success,
          clearUpdatingCourseId: true,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          errorMessage: 'Không thể cập nhật tiến độ học.',
          clearUpdatingCourseId: true,
        ),
      );
    }
  }

  void _emitCourses(List<MyLearningCourse> courses) {
    emit(
      state.copyWith(
        status:
            courses.isEmpty ? MyLearningStatus.empty : MyLearningStatus.success,
        courses: courses,
        clearUpdatingCourseId: true,
        clearErrorMessage: true,
      ),
    );
  }
}
