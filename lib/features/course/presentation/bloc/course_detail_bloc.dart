import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/enroll_course.dart';
import '../../domain/usecases/get_course_detail.dart';
import 'course_detail_event.dart';
import 'course_detail_state.dart';

/// BLoC quản lý màn hình chi tiết khóa học và hành động enroll.
///
/// BLoC này không nhận trực tiếp object Course từ list page nữa.
/// Nó nhận course id, gọi `GetCourseDetail`, rồi UI render theo state.
class CourseDetailBloc extends Bloc<CourseDetailEvent, CourseDetailState> {
  final GetCourseDetail _getCourseDetail;
  final EnrollCourse _enrollCourse;
  final String _currentUserId;

  CourseDetailBloc({
    required GetCourseDetail getCourseDetail,
    required EnrollCourse enrollCourse,
    required String currentUserId,
  })  : _getCourseDetail = getCourseDetail,
        _enrollCourse = enrollCourse,
        _currentUserId = currentUserId,
        super(const CourseDetailState.initial()) {
    on<CourseDetailStarted>(_onStarted);
    on<CourseDetailRetried>(_onRetried);
    on<CourseEnrollPressed>(_onEnrollPressed);
  }

  Future<void> _onStarted(
    CourseDetailStarted event,
    Emitter<CourseDetailState> emit,
  ) async {
    await _loadCourse(event.courseId, emit);
  }

  Future<void> _onRetried(
    CourseDetailRetried event,
    Emitter<CourseDetailState> emit,
  ) async {
    final courseId = state.courseId;
    if (courseId == null) return;

    await _loadCourse(courseId, emit);
  }

  Future<void> _onEnrollPressed(
    CourseEnrollPressed event,
    Emitter<CourseDetailState> emit,
  ) async {
    final course = state.course;
    if (course == null || !course.canEnroll || state.isEnrollSubmitting) {
      return;
    }

    emit(
      state.copyWith(
        enrollStatus: CourseEnrollStatus.submitting,
        clearEnrollErrorMessage: true,
      ),
    );

    try {
      final enrollment = await _enrollCourse(
        courseId: course.id,
        userId: _currentUserId,
      );

      emit(
        state.copyWith(
          enrollStatus: CourseEnrollStatus.success,
          enrollment: enrollment,
          clearEnrollErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          enrollStatus: CourseEnrollStatus.failure,
          enrollErrorMessage: 'Không thể đăng ký khóa học. Vui lòng thử lại.',
        ),
      );
    }
  }

  Future<void> _loadCourse(
    String courseId,
    Emitter<CourseDetailState> emit,
  ) async {
    emit(
      state.copyWith(
        courseId: courseId,
        detailStatus: CourseDetailStatus.loading,
        enrollStatus: CourseEnrollStatus.idle,
        clearErrorMessage: true,
        clearEnrollErrorMessage: true,
      ),
    );

    try {
      final course = await _getCourseDetail(courseId);

      if (course == null) {
        emit(
          state.copyWith(
            detailStatus: CourseDetailStatus.failure,
            errorMessage: 'Không tìm thấy khóa học.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          detailStatus: CourseDetailStatus.success,
          course: course,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          detailStatus: CourseDetailStatus.failure,
          errorMessage: 'Không thể tải chi tiết khóa học.',
        ),
      );
    }
  }
}
